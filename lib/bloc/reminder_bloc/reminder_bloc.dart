import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Model/Reminder.dart';
import 'package:personal_expense_management/bloc/reminder_bloc/reminder_event.dart';
import 'package:personal_expense_management/bloc/reminder_bloc/reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final List<Reminder> reminders;

  ReminderBloc(this.reminders) : super(ReminderUpdateState(reminders)) {
    on<AddReminderEvent>((event, emit) async {
      int id = await DatabaseHelper().insertReminder(event.newRem);
      Reminder updatedBudget = Reminder(id: id, date: event.newRem.date, description: event.newRem.description, repeat_option: event.newRem.repeat_option);
      reminders.add(updatedBudget);
      emit(ReminderUpdateState(List.from(reminders)));
    });

    on<UpdateReminderEvent>((event, emit) async {
      final index = reminders.indexWhere((wallet) => wallet.id == event.updRem.id);
      if (index != -1) {
        reminders[index] = event.updRem;
        await DatabaseHelper().updateReminder(event.updRem);
        emit(ReminderUpdateState(List.from(reminders)));
      } else {
        throw Exception('Category not found');
      }
    });

    on<RemoveReminderEvent>((event, emit) async {
      reminders.removeWhere((wallet) => wallet.id == event.remRem.id);
      await DatabaseHelper().deleteReminder(event.remRem.id!);
      emit(ReminderUpdateState(List.from(reminders)));
    });
  }
}