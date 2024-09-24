import 'package:personal_expense_management/Model/Saving.dart';

abstract class SavingEvent {}

class AddSavingEvent extends SavingEvent {
  final Saving newSav;

  AddSavingEvent(this.newSav);
}

class UpdateSavingEvent extends SavingEvent {
  final Saving updSav;

  UpdateSavingEvent(this.updSav);
}

class RemoveSavingEvent extends SavingEvent {
  final Saving remSav;

  RemoveSavingEvent(this.remSav);
}