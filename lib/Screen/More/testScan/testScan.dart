import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ScanBillPage extends StatefulWidget {
  @override
  _ScanBillPageState createState() => _ScanBillPageState();
}

class _ScanBillPageState extends State<ScanBillPage> {
  File? _image;
  String _scannedText = "";
  String _invoiceDate = "";
  String _totalAmount = "";
  final ImagePicker _picker = ImagePicker();

  // Function to capture an image from the camera
  Future<void> _getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _scanText(pickedFile.path);
    }
  }

  // OCR function to scan text from the invoice and extract date and total amount
  Future<void> _scanText(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);

    String extractedText = "";
    List<TextLine> listLine = [];
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        listLine.add(line);
      }
    }

    // Sort lines by their horizontal positions
    listLine.sort((a, b) => a.boundingBox.left.compareTo(b.boundingBox.left));
    for (TextLine line in listLine) {
      extractedText += " " + line.text;
    }

    // Normalize text for case-insensitive and accent-insensitive matching
    String normalizedText = _normalizeText(extractedText);

    // Extract invoice date and total amount
    _invoiceDate = _extractDate(normalizedText);
    _totalAmount = _extractTotalAmount(normalizedText);

    setState(() {
      _scannedText = extractedText;
    });
    textRecognizer.close();
  }

  // Function to extract date from the scanned text
  String _extractDate(String text) {
    final datePattern = RegExp(
      r'(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{2,4})', // e.g., 12/05/2024, 12-05-2024
    );
    final match = datePattern.firstMatch(text);
    return match != null ? match.group(0) ?? "" : "Không tìm thấy ngày lập hóa đơn";
  }

  // Function to extract the total amount from the scanned text
  String _extractTotalAmount(String text) {
    final amountPattern = RegExp(
      r'(total|amount due|tong|cong|thanh toan|tong tien|phai)\s*[:\-]?\s*\$?(\d+[.,]?\d*)',
      caseSensitive: false,
    );
    final match = amountPattern.firstMatch(text);
    return match != null ? match.group(2) ?? "" : "Không tìm thấy số tiền cần thanh toán";
  }

  // Function to normalize text: convert to lowercase and remove Vietnamese accents
  String _normalizeText(String text) {
    final vietnameseAccentsMap = {
      'a': ['à', 'á', 'ạ', 'ả', 'ã', 'â', 'ầ', 'ấ', 'ậ', 'ẩ', 'ẫ', 'ă', 'ằ', 'ắ', 'ặ', 'ẳ', 'ẵ'],
      'e': ['è', 'é', 'ẹ', 'ẻ', 'ẽ', 'ê', 'ề', 'ế', 'ệ', 'ể', 'ễ'],
      'i': ['ì', 'í', 'ị', 'ỉ', 'ĩ'],
      'o': ['ò', 'ó', 'ọ', 'ỏ', 'õ', 'ô', 'ồ', 'ố', 'ộ', 'ổ', 'ỗ', 'ơ', 'ờ', 'ớ', 'ợ', 'ở', 'ỡ'],
      'u': ['ù', 'ú', 'ụ', 'ủ', 'ũ', 'ư', 'ừ', 'ứ', 'ự', 'ử', 'ữ'],
      'y': ['ỳ', 'ý', 'ỵ', 'ỷ', 'ỹ'],
      'd': ['đ'],
    };

    vietnameseAccentsMap.forEach((nonAccent, accents) {
      for (var accent in accents) {
        text = text.replaceAll(accent, nonAccent);
        text = text.replaceAll(accent.toUpperCase(), nonAccent.toUpperCase());
      }
    });

    return text.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quét hóa đơn'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            _image != null
                ? Image.file(
              _image!,
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            )
                : Text('Chưa có hình ảnh nào'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImageFromCamera,
              child: Text('Chụp ảnh hóa đơn'),
            ),
            SizedBox(height: 20),
            _scannedText.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Văn bản quét được:\n$_scannedText',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Ngày lập hóa đơn: $_invoiceDate',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Số tiền cần thanh toán: $_totalAmount',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
                : Text('Chưa có văn bản nào được quét'),
          ],
        ),
      ),
    );
  }
}
