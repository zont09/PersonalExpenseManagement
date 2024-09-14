import 'package:personal_expense_management/Model/Budget.dart';
import 'package:personal_expense_management/Model/BudgetDetail.dart';

abstract class BudgetDetailState {}

class BudgetDetailInitialState extends BudgetDetailState {}

class BudgetDetailUpdateState extends BudgetDetailState {
  final List<BudgetDetail> updBudgetDet;

  BudgetDetailUpdateState(this.updBudgetDet);
}