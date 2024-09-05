import 'package:flutter/foundation.dart';
import 'package:personal_expense_management/Model/Currency.dart';

class Parameter {
  Currency currency;

  Parameter({required this.currency});

  factory Parameter.fromMap(Map<String, dynamic> json, Currency Cur) {
    return Parameter(
        currency: Cur,
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'currency': currency,
    };
    return data;
  }
}