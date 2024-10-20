import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';

class InvoiceScannerScreen extends StatefulWidget {
  @override
  _InvoiceScannerScreenState createState() => _InvoiceScannerScreenState();
}

class _InvoiceScannerScreenState extends State<InvoiceScannerScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(firstCamera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller?.initialize();
  }

  Future<void> _scanInvoice() async {
    if (_initializeControllerFuture == null) return;
    try {
      await _initializeControllerFuture;
      final image = await _controller?.takePicture();
      if (image != null) {
        final recognizedText = await _performOCR(image.path);
        final invoiceData = _extractInvoiceData(recognizedText);
        _displayInvoiceData(invoiceData);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> _performOCR(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    return recognizedText.text;
  }

  Map<String, String> _extractInvoiceData(String text) {
    // Đây là nơi bạn sẽ thực hiện phân tích văn bản để trích xuất thông tin
    // Ví dụ đơn giản:
    final dateRegex = RegExp(r'\d{2}/\d{2}/\d{4}');
    final amountRegex = RegExp(r'\d{1,3}(,\d{3})*(\.\d+)? đ');

    final date = dateRegex.firstMatch(text)?.group(0) ?? 'Không tìm thấy ngày';
    final amount = amountRegex.firstMatch(text)?.group(0) ?? 'Không tìm thấy số tiền';

    return {'date': date, 'amount': amount};
  }

  void _displayInvoiceData(Map<String, String> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông tin hóa đơn'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Ngày lập: ${data['date']}'),
              Text('Giá trị: ${data['amount']}'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Đóng'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quét hóa đơn')),
      body: _initializeControllerFuture == null
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _controller != null
                ? CameraPreview(_controller!)
                : Center(child: Text('Không thể khởi tạo camera'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanInvoice,
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}