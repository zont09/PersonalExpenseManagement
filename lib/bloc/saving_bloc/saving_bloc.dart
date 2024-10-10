import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Model/Budget.dart';
import 'package:personal_expense_management/Model/Saving.dart';
import 'package:personal_expense_management/bloc/budget_bloc/budget_event.dart';
import 'package:personal_expense_management/bloc/budget_bloc/budget_state.dart';
import 'package:personal_expense_management/bloc/saving_bloc/saving_event.dart';
import 'package:personal_expense_management/bloc/saving_bloc/saving_state.dart';

class SavingBloc extends Bloc<SavingEvent, SavingState> {
  final List<Saving> savings;

  SavingBloc(this.savings) : super(SavingUpdateState(savings)) {
    on<AddSavingEvent>((event, emit) async {
      int _id = await DatabaseHelper().insertSaving(event.newSav);
      Saving updateSaving = Saving(
        id: _id,
          name: event.newSav.name,
          target_amount: event.newSav.target_amount,
          target_date: event.newSav.target_date,
          current_amount: event.newSav.current_amount,
          currency: event.newSav.currency,
          is_finished: event.newSav.is_finished);
      savings.add(updateSaving);
      emit(SavingUpdateState(List.from(savings)));
    });

    on<UpdateSavingEvent>((event, emit) async {
      final index =
          savings.indexWhere((wallet) => wallet.id == event.updSav.id);
      if (index != -1) {
        savings[index] = event.updSav;
        await DatabaseHelper().updateSaving(event.updSav);
        emit(SavingUpdateState(List.from(savings)));
      } else {
        throw Exception('Saving not found');
      }
    });

    on<RemoveSavingEvent>((event, emit) async {
      savings.removeWhere((wallet) => wallet.id == event.remSav.id);
      await DatabaseHelper().deleteSaving(event.remSav.id!);
      emit(SavingUpdateState(List.from(savings)));
    });
  }
}
