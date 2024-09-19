import 'package:personal_expense_management/Model/Budget.dart';
import 'package:personal_expense_management/Model/Currency.dart';

abstract class CurrencyState {}

class CurrencyInitialState extends CurrencyState {}

class CurrencyUpdateState extends CurrencyState {
  final List<Currency> updCur;

  CurrencyUpdateState(this.updCur);
}