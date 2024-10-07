import 'package:personal_expense_management/Model/Budget.dart';
import 'package:personal_expense_management/Model/Reminder.dart';

abstract class ReminderEvent {}

class AddReminderEvent extends ReminderEvent {
  final Reminder newRem;

  AddReminderEvent(this.newRem);
}

class UpdateReminderEvent extends ReminderEvent {
  final Reminder updRem;

  UpdateReminderEvent(this.updRem);
}

class RemoveReminderEvent extends ReminderEvent {
  final Reminder remRem;

  RemoveReminderEvent(this.remRem);
}