import 'package:personal_expense_management/Model/Reminder.dart';

abstract class ReminderState {}

class ReminderInitialState extends ReminderState {}

class ReminderUpdateState extends ReminderState {
  final List<Reminder> updRem;

  ReminderUpdateState(this.updRem);
}