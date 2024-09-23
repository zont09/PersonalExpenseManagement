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
  final ImagePicker _picker = ImagePicker();

  // Hàm để chụp ảnh từ máy ảnh
  Future<void> _getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _scanText(pickedFile.path);
    }
  }

  // Hàm OCR để quét văn bản từ hóa đơn theo hàng ngang
  Future<void> _scanText(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);

    String extractedText = "";
    List<TextLine> listLine = [];
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        // String lineText = _rearrangeWordsByHorizontal(line);
        // print("line: ${line.text} - ${line.boundingBox.left}");
        // extractedText += "$lineText\n";
        listLine.add(line);
      }
    }
    listLine.sort((a, b) => a.boundingBox.left.compareTo(b.boundingBox.left));
    for(TextLine line in listLine) {
      extractedText += " " + line.text;
    }


    setState(() {
      _scannedText = extractedText;
    });
    textRecognizer.close();
  }

  // Hàm để sắp xếp lại các từ trong một hàng theo tọa độ
  String _rearrangeWordsByHorizontal(TextLine line) {
    // Sắp xếp các từ theo tọa độ X của chúng để đảm bảo hàng ngang
    List<TextElement> elements = line.elements;
    elements.sort((a, b) => a.boundingBox.left.compareTo(b.boundingBox.left));

    return elements.map((e) => e.text).join(" ");
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
              child: Text(
                'Văn bản quét được:\n$_scannedText',
                style: TextStyle(fontSize: 16),
              ),
            )
                : Text('Chưa có văn bản nào được quét'),
          ],
        ),
      ),
    );
  }
}
