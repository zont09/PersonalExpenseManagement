import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Model/Budget.dart';
import 'package:personal_expense_management/Model/BudgetDetail.dart';
import 'package:personal_expense_management/bloc/budget_detail_bloc/budget_detail_event.dart';
import 'package:personal_expense_management/bloc/budget_detail_bloc/budget_detail_state.dart';

class BudgetDetailBloc extends Bloc<BudgetDetailEvent, BudgetDetailState> {
  final List<BudgetDetail> budgetDets;

  BudgetDetailBloc(this.budgetDets) : super(BudgetDetailUpdateState(budgetDets)) {
    on<AddBudgetDetailEvent>((event, emit) async {
      int id = await DatabaseHelper().insertBudgetDetail(event.newBudDet);
      BudgetDetail newBuddet = BudgetDetail(id: id,id_budget: event.newBudDet.id_budget, amount: event.newBudDet.amount, category: event.newBudDet.category, currency: event.newBudDet.currency, is_repeat: event.newBudDet.is_repeat);
      budgetDets.add(newBuddet);
      emit(BudgetDetailUpdateState(List.from(budgetDets)));
    });

    on<UpdateBudgetDetailEvent>((event, emit) async {
      final index = budgetDets.indexWhere((wallet) => wallet.id == event.updBudDet.id);
      if (index != -1) {
        budgetDets[index] = event.updBudDet;
        await DatabaseHelper().updateBudgetDetail(event.updBudDet);
        emit(BudgetDetailUpdateState(List.from(budgetDets)));
      } else {
        throw Exception('Category not found');
      }
    });

    on<RemoveBudgetDetailEvent>((event, emit) async {
      budgetDets.removeWhere((wallet) => wallet.id == event.remBudDet.id);
      await DatabaseHelper().deleteBudgetDetail(event.remBudDet.id!);
      emit(BudgetDetailUpdateState(List.from(budgetDets)));
    });
  }
}