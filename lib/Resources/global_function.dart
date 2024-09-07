import 'package:intl/intl.dart';
import 'package:personal_expense_management/Model/TransactionModel.dart';

class GlobalFunction {
  static String formatCurrency(double number) {
    NumberFormat numberFormat = NumberFormat('#,##0', 'vi');
    String integerPart = numberFormat.format(number.floor());
    String decimalPart = '';
    if (number != number.floor()) {
      decimalPart = ',' + ((number - number.floor()).toStringAsFixed(2).substring(2));
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
}