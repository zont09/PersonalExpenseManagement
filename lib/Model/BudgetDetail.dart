import 'package:personal_expense_management/Model/Budget.dart';
import 'package:personal_expense_management/Model/Category.dart';
import 'package:personal_expense_management/Model/Currency.dart';

class BudgetDetail {
  int? id;
  Budget id_budget;
  double amount;
  Category category;
  Currency currency;
  int is_repeat;

  BudgetDetail({this.id, required this.id_budget, required this.amount, required this.category,required this.currency, required this.is_repeat});

  factory BudgetDetail.fromMap(Map<String, dynamic> json, Category Cat, Budget Bud, Currency Cur) {
    return BudgetDetail(
      id: json['id'],
      id_budget: Bud,
      amount: json['amount'],
      category: Cat,
      currency: Cur,
      is_repeat: json['is_repeat'],
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'id_budget': id_budget.id,
      'amount': amount,
      'category': category.id,
      'currency': currency.id,
      'is_repeat': is_repeat,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}