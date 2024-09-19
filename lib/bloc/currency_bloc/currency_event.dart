import 'package:personal_expense_management/Model/Budget.dart';
import 'package:personal_expense_management/Model/Category.dart';
import 'package:personal_expense_management/Model/Currency.dart';

abstract class CurrencyEvent {}

class AddCurrencyEvent extends CurrencyEvent {
  final Currency newCur;

  AddCurrencyEvent(this.newCur);
}

class UpdateCurrencyEvent extends CurrencyEvent {
  final Currency updCur;

  UpdateCurrencyEvent(this.updCur);
}

class RemoveCurrencyEvent extends CurrencyEvent {
  final Currency remCur;

  RemoveCurrencyEvent(this.remCur);
}