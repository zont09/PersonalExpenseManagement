import 'package:personal_expense_management/Model/Category.dart';
import 'package:personal_expense_management/Model/Currency.dart';
import 'package:personal_expense_management/Model/RepeatOption.dart';
import 'package:personal_expense_management/Model/Wallet.dart';

class BudgetDetail {
  int? id;
  int id_budget;
  double amount;
  Category category;

  BudgetDetail({this.id, required this.id_budget, required this.amount, required this.category});

  factory BudgetDetail.fromMap(Map<String, dynamic> json, Category Cat) {
    return BudgetDetail(
      id: json['id'],
      id_budget: json['id_budget'],
      amount: json['amount'],
      category: Cat,
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'id_budget': id_budget,
      'amount': amount,
      'category': category,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}