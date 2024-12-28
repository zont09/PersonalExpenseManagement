import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class ReceiptScannerScreen extends StatefulWidget {
  const ReceiptScannerScreen({Key? key}) : super(key: key);

  @override
  _ReceiptScannerScreenState createState() => _ReceiptScannerScreenState();
}

class _ReceiptScannerScreenState extends State<ReceiptScannerScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  Map<String, dynamic>? _receiptData;
  bool _isProcessing = false;

  // Chụp ảnh từ camera
  Future<void> _getImageFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 100,
      );

      if (photo != null) {
        setState(() {
          _image = File(photo.path);
          _isProcessing = true;
        });
        await _processReceipt(photo.path);
      }
    } catch (e) {
      print('Error taking picture: $e');
      _showError('Không thể chụp ảnh: $e');
    }
  }

  // Chọn ảnh từ thư viện
  Future<void> _getImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image != null) {
        setState(() {
          _image = File(image.path);
          _isProcessing = true;
        });
        await _processReceipt(image.path);
      }
    } catch (e) {
      print('Error picking image: $e');
      _showError('Không thể chọn ảnh: $e');
    }
  }

  // Xử lý ảnh với Mindee API
  Future<void> _processReceipt(String imagePath) async {
    try {
      final url = Uri.parse('https://api.mindee.net/v1/products/mindee/expense_receipts/v5/predict');
      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Token d1250a3ec01bce694443f889d67c7f48'
        ..files.add(await http.MultipartFile.fromPath('document', imagePath)); // Thêm tệp ảnh vào yêu cầu

      final response = await request.send();
      setState(() => _isProcessing = false);

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Đọc dữ liệu phản hồi
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        setState(() => _receiptData = data);
      } else {
        final errorData = await response.stream.bytesToString();
        print('Error Data: $errorData');  // In phản hồi lỗi chi tiết
        _showError('Lỗi xử lý hoá đơn: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      _showError('Lỗi khi xử lý hoá đơn: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  String formatVND(String? amountStr) {
    if (amountStr == null) return 'N/A';
    final amount = double.tryParse(amountStr) ?? 0;
    // Nếu giá trị nhỏ hơn 1000, giả định rằng giá trị bị rút gọn, nhân với 1000 để chuyển sang VND
    if (amount < 1000) {
      return (amount * 1000).toStringAsFixed(0);
    }
    return amount.toString();
  }

  // Format lại dữ liệu từ Mindee để hiển thị
  Widget _buildReceiptDetails() {
    if (_receiptData == null) return SizedBox();

    try {
      final prediction = _receiptData!['document']['inference']['prediction'];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem('Tổng tiền', '${formatVND(prediction['total_amount']['value']?.toString())} VND'),

          _buildDetailItem('Ngày', prediction['date']?['value']?.toString() ?? 'N/A'),
          _buildDetailItem('Nhà cung cấp', prediction['supplier_name']?['value']?.toString() ?? 'N/A'),
          _buildDetailItem('Địa chỉ', prediction['supplier_address']?['value']?.toString() ?? 'N/A'),
          if (prediction['taxes'] != null && prediction['taxes'].isNotEmpty)
            _buildDetailItem(
              'Thuế',
              prediction['taxes']
                  .map((tax) => '${tax['value']?.toString() ?? ''} ${tax['currency']?.toString() ?? ''}')
                  .join(', '),
            ),
          if (prediction['category'] != null)
            _buildDetailItem('Danh mục', prediction['category']['value'].toString()),
        ],
      );
    } catch (e) {
      return Text('Lỗi hiển thị dữ liệu: $e');
    }
  }


  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label + ':',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quét Hoá Đơn'),
        actions: [
          if (_image != null)
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _image = null;
                  _receiptData = null;
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            if (_image != null) ...[
              Image.file(
                _image!,
                height: 300,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
            ],
            if (_isProcessing)
              Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Đang xử lý hoá đơn...'),
                ],
              )
            else if (_receiptData != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildReceiptDetails(),
              )
            else
              Text('Chụp ảnh hoá đơn để bắt đầu'),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: _getImageFromCamera,
              icon: Icon(Icons.camera_alt),
              label: Text('Chụp ảnh'),
            ),
            ElevatedButton.icon(
              onPressed: _getImageFromGallery,
              icon: Icon(Icons.photo_library),
              label: Text('Chọn ảnh'),
            ),
          ],
        ),
      ),
    );
  }
}