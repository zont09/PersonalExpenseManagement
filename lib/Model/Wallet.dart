import 'package:personal_expense_management/Model/Currency.dart';

class Wallet {
  int? id;
  String name;
  double amount;
  Currency currency;
  String note;

  Wallet({this.id, required this.name, required this.amount, required this.currency, required this.note});

  factory Wallet.fromMap(Map<String, dynamic> json, Currency Cur) {
    return Wallet(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      note: json['note'],
      currency: Cur,
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'name': name,
      'amount': amount,
      'currency': currency.id,
      'note': note
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
  Wallet copyWith({
    int? id,
    String? name,
    double? amount,
    Currency? currency,
    String? note,
  }) {
    return Wallet(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      note: note ?? this.note,
    );
  }
}