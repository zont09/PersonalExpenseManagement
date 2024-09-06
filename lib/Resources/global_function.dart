import 'package:intl/intl.dart';

class GlobalFunction {
  static String formatCurrency(double number) {
    // Sử dụng NumberFormat cho phần nguyên
    NumberFormat numberFormat = NumberFormat('#,##0', 'vi');

    // Định dạng phần nguyên trước dấu thập phân
    String integerPart = numberFormat.format(number.floor());

    // Xử lý phần thập phân nếu có
    String decimalPart = '';
    if (number != number.floor()) {
      decimalPart = ',' + ((number - number.floor()).toStringAsFixed(2).substring(2));
    }

    // Kết hợp phần nguyên và phần thập phân
    return integerPart.replaceAll(',', '.') + decimalPart;
  }
}