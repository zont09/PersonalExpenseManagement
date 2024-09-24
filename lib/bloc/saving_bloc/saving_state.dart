import 'package:personal_expense_management/Model/Saving.dart';

abstract class SavingState {}

class SavingInitialState extends SavingState {}

class SavingUpdateState extends SavingState {
  final List<Saving> updSaving;

  SavingUpdateState(this.updSaving);
}