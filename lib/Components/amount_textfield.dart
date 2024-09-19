import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AmountTextfield extends StatefulWidget {
  final TextEditingController controllerTF;
  final bool isEdit;
  final String hintText;
  const AmountTextfield({super.key, required this.controllerTF, required this.isEdit,this.hintText = "Nhập số tiền"});

  @override
  State<AmountTextfield> createState() => _AmountTextfieldState();
}

class _AmountTextfieldState extends State<AmountTextfield> {
  bool _isEnterDot = false;
  String _preTextAmount = "";

  static String formatCurrency2(String input) {
    // Kiểm tra xem chuỗi có chứa phần thập phân không
    List<String> parts = input.split('.');

    // Xử lý phần nguyên
    String integerPart = parts[0].replaceAll(RegExp(r'[^0-9]'), '');
    NumberFormat numberFormat = NumberFormat('#,##0', 'vi');
    String formattedInteger =
    numberFormat.format(int.tryParse(integerPart) ?? 0);

    // Xử lý phần thập phân (nếu có)
    String decimalPart = '';
    if (parts.length > 1) {
      decimalPart = parts[1]; // Lấy phần thập phân sau dấu '.'

      // Nếu phần thập phân trống (ví dụ '1000000.'), thì mặc định là '0'
      return formattedInteger.replaceAll(',', '.') + ',' + decimalPart;
    }

    return formattedInteger.replaceAll(',', '.');
  }

  @override
  Widget build(BuildContext context) {
    final _controllerAmount = widget.controllerTF;
    return TextField(
      enabled: widget.isEdit,

      controller: _controllerAmount,
      keyboardType: TextInputType.numberWithOptions(
          decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(
            !_isEnterDot ? r'[0-9,]' : r'[0-9]')),
        // Cho phép số và dấu phẩy
      ],
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: widget.hintText,
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey, fontSize: 16)
      ),
      onChanged: (value) {
        // Xử lý giá trị hiển thị trong TextField
        if (value.length < _preTextAmount.length) {
          if (_preTextAmount[
          _preTextAmount.length - 1] ==
              ',') {
            setState(() {
              _isEnterDot = false;
            });
          }
        }
        late String formatted = formatCurrency2(
            value
                .replaceAll('.', '')
                .replaceAll(',', '.'));
        print(
            "Value: $value  -  Formated: $formatted");
        _controllerAmount.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(
              offset: formatted.length),
        );
        _preTextAmount = value;
      },
    );
  }
}
