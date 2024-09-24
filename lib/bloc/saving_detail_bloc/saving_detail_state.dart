import 'package:personal_expense_management/Model/SavingDetail.dart';

abstract class SavingDetailState {}

class SavingDetailInitialState extends SavingDetailState {}

class SavingDetailUpdateState extends SavingDetailState {
  final List<SavingDetail> updSavDet;

  SavingDetailUpdateState(this.updSavDet);
}