import 'package:flutter/material.dart';
class ErrorDialog {
  static void showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Center(child: Text('Lỗi')),
          content: Text(errorMessage, style: TextStyle(fontSize: 18),),
          actions: <Widget>[
            TextButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}