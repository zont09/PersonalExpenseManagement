import 'package:personal_expense_management/Model/BudgetDetail.dart';

abstract class BudgetDetailEvent {}

class AddBudgetDetailEvent extends BudgetDetailEvent {
  final BudgetDetail newBudDet;

  AddBudgetDetailEvent(this.newBudDet);
}

class UpdateBudgetDetailEvent extends BudgetDetailEvent {
  final BudgetDetail updBudDet;

  UpdateBudgetDetailEvent(this.updBudDet);
}

class RemoveBudgetDetailEvent extends BudgetDetailEvent {
  final BudgetDetail remBudDet;

  RemoveBudgetDetailEvent(this.remBudDet);
}