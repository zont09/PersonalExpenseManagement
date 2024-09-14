import 'package:personal_expense_management/Model/Budget.dart';
import 'package:personal_expense_management/Model/Category.dart';

abstract class BudgetEvent {}

class AddBudgetEvent extends BudgetEvent {
  final Budget newBud;

  AddBudgetEvent(this.newBud);
}

class UpdateBudgetEvent extends BudgetEvent {
  final Budget updBud;

  UpdateBudgetEvent(this.updBud);
}

class RemoveBudgetEvent extends BudgetEvent {
  final Budget remBud;

  RemoveBudgetEvent(this.remBud);
}