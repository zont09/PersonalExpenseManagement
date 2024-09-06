import 'package:personal_expense_management/Model/Category.dart';
import 'package:personal_expense_management/Model/RepeatOption.dart';
import 'package:personal_expense_management/Model/Wallet.dart';

class TransactionModel {
  int? id;
  String date;
  double amount;
  Wallet wallet;
  Category category;
  String note;
  String description;
  RepeatOption repeat_option;

  TransactionModel({this.id, required this.date, required this.amount, required this.wallet, required this.category, required this.note, required this.description, required this.repeat_option});

  factory TransactionModel.fromMap(Map<String, dynamic> json, Wallet Wat, Category Cat, RepeatOption Rep) {
    return TransactionModel(
      id: json['id'],
      date: json['date'],
      amount: json['amount'],
      wallet: Wat,
      category: Cat,
      note: json['note'],
      description: json['description'],
      repeat_option: Rep,
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'date': date,
      'amount': amount,
      'wallet': wallet.id,
      'category': category.id,
      'note': note,
      'description': description,
      'repeat_option': repeat_option.id,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}