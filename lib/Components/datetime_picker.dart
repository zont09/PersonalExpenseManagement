import "package:flutter/material.dart";
import "package:intl/intl.dart";

Future<void> openDatetimePicker(BuildContext context, TextEditingController _controllerDate, Function(String) onchanged) async {
  DateTime? selectedDate = await showDatePicker(
    context: context,
    locale: Locale("vi", "VN"),
    initialDate: DateFormat('dd/MM/yyyy').parse(_controllerDate.text), // Ngày mặc định là ngày hiện tại
    firstDate: DateTime(2000),   // Ngày bắt đầu
    lastDate: DateTime(2100),    // Ngày kết thúc
    helpText: 'Chọn ngày giao dịch',     // Tiêu đề của DatePicker
    cancelText: 'Huỷ',        // Nút hủy
    confirmText: 'Xác nhận',           // Nút xác nhận
    fieldLabelText: 'Enter date',// Nhãn của trường nhập
  );

  if (selectedDate != null) {
    _controllerDate.text = DateFormat('dd/MM/yyyy').format(selectedDate);
    print("Selected date: $selectedDate");
    onchanged(DateFormat('dd/MM/yyyy').format(selectedDate));
  }
}