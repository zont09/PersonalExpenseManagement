import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart'; // Đảm bảo bạn đã thêm package này vào pubspec.yaml

Future<void> openMonthPicker(
    BuildContext context,
    String? locale,
    DateTime? initialDate,
    Function(DateTime) onDateSelected,
    ) async {
  final localeObj = locale != null ? Locale(locale) : null;
  final selected = await showMonthYearPicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: DateTime(2019),
    lastDate: DateTime(2030),
    locale: localeObj,
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.blue, // Màu nền tiêu đề
            onPrimary: Colors.white, // Màu chữ tiêu đề
            surface: Colors.white, // Màu nền picker
            onSurface: Colors.black, // Màu chữ picker
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              fontSize: 12,
              color: Colors.black, // Màu chữ cho nội dung picker
            ),
            titleLarge: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue, // Màu chữ cho tiêu đề picker
            ),
          ),
        ),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            child: child,
          ),
        ),
      );
    },
  );

  if (selected != null) {
    onDateSelected(selected); // Gọi callback để cập nhật giá trị dateTransaction
  }
}
