import 'package:personal_expense_management/Model/SavingDetail.dart';

abstract class SavingDetailEvent {}

class AddSavingDetailEvent extends SavingDetailEvent {
  final SavingDetail newSavDet;

  AddSavingDetailEvent(this.newSavDet);
}

class UpdateSavingDetailEvent extends SavingDetailEvent {
  final SavingDetail updSavDet;

  UpdateSavingDetailEvent(this.updSavDet);
}

class RemoveSavingDetailEvent extends SavingDetailEvent {
  final SavingDetail remSavDet;

  RemoveSavingDetailEvent(this.remSavDet);
}