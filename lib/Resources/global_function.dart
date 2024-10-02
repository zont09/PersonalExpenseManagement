import 'package:intl/intl.dart';
import 'package:personal_expense_management/Model/TransactionModel.dart';

class GlobalFunction {
  static String formatCurrency(double number, int numDecimal) {
    NumberFormat numberFormat = NumberFormat('#,##0', 'vi');
    String integerPart = numberFormat.format(number.floor());
    String decimalPart = '';
    if (number != number.floor()) {
      decimalPart = ',' + ((number - number.floor()).toStringAsFixed(numDecimal).substring(numDecimal));
    }
    return integerPart.replaceAll(',', '.') + decimalPart;
  }

  static List<TransactionModel> getTransactionByDate(List<TransactionModel> transactions,DateTime date) {
    return transactions.where((transaction) {
      DateTime transactionDate = DateTime.parse(transaction.date);
      return (transactionDate.day == date.day && transactionDate.year == date.year && transactionDate.month == date.month && transactionDate.year == date.year);
    }).toList();
  }

  static List<TransactionModel> getTransactionByWallet(List<TransactionModel> transactions,int id) {
    return transactions.where((transaction) => transaction.wallet.id == id || id == 0).toList();
  }

  static List<TransactionModel> getTransactionByNote(List<TransactionModel> transactions,String searchText) {
    return transactions.where((transaction) => searchText.length <= 0 || GlobalFunction.compareStrings(transaction.note, searchText)).toList();
  }

  static List<TransactionModel> getTransactionByCategories(List<TransactionModel> transactions,Map<String, bool> mapI, Map<String, bool> mapO) {
    return transactions.where((transaction) => (mapI[transaction.category.name] ?? false) || (mapO[transaction.category.name] ?? false)).toList();
  }

  static List<TransactionModel> getTransactionByAll(List<TransactionModel> transactions,DateTime date, int id, String searchText , Map<String, bool> mapI, Map<String, bool> mapO) {
    return transactions.where((transaction) {
      DateTime transactionDate = DateTime.parse(transaction.date);
      return (transactionDate.day == date.day && transactionDate.year == date.year && transactionDate.month == date.month && transactionDate.year == date.year) &&
          (transaction.wallet.id == id || id == 0) &&
          (searchText.length <= 0 || GlobalFunction.compareStrings(transaction.note, searchText)) &&
          ((mapI[transaction.category.name] ?? false) || (mapO[transaction.category.name] ?? false));
    }).toList();
  }

  static int getDaysInMonth(int year, int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }
    DateTime firstDayOfNextMonth = DateTime(year, month + 1, 1);
    DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(Duration(days: 1));
    return lastDayOfMonth.day;
  }

  static double convernCurrency(double amount, double valueA, double valueB) {
    return amount * valueA / valueB;
  }

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

  static String removeDiacritics(String str) {
    const withDiacritics = 'áàảãạâấầẩẫậăắằẳẵặäåāçđéèẻẽẹêếềểễệëēíìỉĩịîïīłñóòỏõọôốồổỗộơớờởỡợöøōúùủũụưứừửữựûüūýỳỷỹỵÿžÁÀẢÃẠÂẤẦẨẪẬĂẮẰẲẴẶÄÅĀÇĐÉÈẺẼẸÊẾỀỂỄỆËĒÍÌỈĨỊÎÏĪŁÑÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÖØŌÚÙỦŨỤƯỨỪỬỮỰÛÜŪÝỲỶỸỴŸŽ';
    const withoutDiacritics = 'aaaaaaaaaaaaaaaaaåacdeeeeeeeeeeeeiiiiiiłnoooooooooooooooooouuuuuuưuuuuuuuuuuuuuuuuyyyyyzAAAAAAAAAAAAAAAAAAAACDEEEEEEEEEEEEIIIIIIŁNOOOOOOOOOOOOOOOOOOUUUUUUƯUUUUUUUUUUUUUYYYYYZ';

    for (int i = 0; i < withDiacritics.length; i++) {
      str = str.replaceAll(withDiacritics[i], withoutDiacritics[i]);
    }
    return str;
  }

  static bool compareStrings(String str1, String str2) {
    String normalizedStr1 = removeDiacritics(str1.toLowerCase());
    String normalizedStr2 = removeDiacritics(str2.toLowerCase());
    return normalizedStr1.contains(normalizedStr2);
  }

  static String shortMoney(double number) {
    if (number <= 999) return number.toString();
    if (number <= 999999) return (number / 1000).floor().toString() + "K";
    if (number <= 999999999) {
      if ((number / 1000000).floor() >= 100)
        return (number / 1000000).floor().toString() + "M";
      else
        return (
            (number / 1000000).floor().toString() +
                "," +
                ((number % 1000000) / 100000).floor().toString() +
                "M"
        );
    }
    if (number <= 999999999999) {
      if ((number / 1000000000).floor() >= 100)
        return (number / 1000000000).floor().toString() + "B";
      else
        return (
            (number / 1000000000).floor().toString() +
                "," +
                ((number % 1000000000) / 100000000).floor().toString() +
                "B"
        );
    }
    if (number <= 999999999999999) {
      if ((number / 1000000000000).floor() >= 100)
        return (number / 1000000000000).floor().toString() + "T";
      else
        return (
            (number / 1000000000000).floor().toString() +
                "," +
                ((number % 1000000000000) / 100000000000).floor().toString() +
                "T"
        );
    }
    return "NaN";
  }

}