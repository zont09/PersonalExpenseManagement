import 'package:flutter/material.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';

class DialogUtils {


  static Future<void> showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(
              color: AppColors.XanhDuong,
            ),
          ),
        ),
      ),
    );
  }
}

enum DialogState { success, error }
