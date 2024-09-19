import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Model/Budget.dart';
import 'package:personal_expense_management/bloc/budget_bloc/budget_event.dart';
import 'package:personal_expense_management/bloc/budget_bloc/budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final List<Budget> budgets;

  BudgetBloc(this.budgets) : super(BudgetUpdateState(budgets)) {
    on<AddBudgetEvent>((event, emit) async {
      int id = await DatabaseHelper().insertBudget(event.newBud);
      Budget updatedBudget = Budget(id: id, date: event.newBud.date);
      budgets.add(updatedBudget);
      emit(BudgetUpdateState(List.from(budgets)));
    });

    on<UpdateBudgetEvent>((event, emit) async {
      final index = budgets.indexWhere((wallet) => wallet.id == event.updBud.id);
      if (index != -1) {
        budgets[index] = event.updBud;
        await DatabaseHelper().updateBudget(event.updBud);
        emit(BudgetUpdateState(List.from(budgets)));
      } else {
        throw Exception('Category not found');
      }
    });

    on<RemoveBudgetEvent>((event, emit) async {
      budgets.removeWhere((wallet) => wallet.id == event.remBud.id);
      await DatabaseHelper().deleteBudgetDetail(event.remBud.id!);
      emit(BudgetUpdateState(List.from(budgets)));
    });
  }
}