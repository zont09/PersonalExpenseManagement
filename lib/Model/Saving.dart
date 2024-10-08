import 'package:personal_expense_management/Model/Currency.dart';

class Saving {
  int? id;
  String name;
  double target_amount;
  String target_date;
  double current_amount;
  Currency currency;
  int is_finished;

  Saving({this.id, required this.name, required this.target_amount, required this.target_date, required this.current_amount, required this.is_finished, required this.currency});
  factory Saving.fromMap(Map<String, dynamic> json, Currency Cur) {
    return Saving(
      id: json['id'],
      name: json['name'],
      target_amount: json['target_amount'],
      target_date: json['target_date'],
      current_amount: json['current_amount'],
      is_finished: json['is_finished'],
      currency: Cur,
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'name': name,
      'target_amount': target_amount,
      'target_date': target_date,
      'current_amount': current_amount,
      'is_finished': is_finished,
      'currency': currency.id,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}