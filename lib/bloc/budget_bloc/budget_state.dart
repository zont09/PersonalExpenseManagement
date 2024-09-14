import 'package:personal_expense_management/Model/Budget.dart';

abstract class BudgetState {}

class BudgetInitialState extends BudgetState {}

class BudgetUpdateState extends BudgetState {
  final List<Budget> updBudget;

  BudgetUpdateState(this.updBudget);
}