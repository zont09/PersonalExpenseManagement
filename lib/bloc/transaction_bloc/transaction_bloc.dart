import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Model/TransactionModel.dart';
import 'package:personal_expense_management/bloc/transaction_bloc/transaction_event.dart';
import 'package:personal_expense_management/bloc/transaction_bloc/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final List<TransactionModel> transactions;

  TransactionBloc(this.transactions)
      : super(TransactionChangedState(transactions)) {
    on<AddTransactionEvent>((event, emit) async {
      int id = await DatabaseHelper().insertTransaction(event.newTrans);
      TransactionModel newTran = TransactionModel(
          id: id,
          date: event.newTrans.date,
          amount: event.newTrans.amount,
          wallet: event.newTrans.wallet,
          category: event.newTrans.category,
          note: event.newTrans.note,
          description: event.newTrans.description,
          repeat_option: event.newTrans.repeat_option);
      transactions.add(newTran);

      emit(TransactionChangedState(transactions));
    });

    on<UpdateTransactionEvent>((event, emit) async {
      final updatedTransactions = List<TransactionModel>.from(transactions)
        ..removeWhere((transaction) => transaction.id == event.newTrans.id)
        ..add(event.newTrans);
      await DatabaseHelper().updateTransaction(event.newTrans);
      emit(TransactionChangedState(updatedTransactions));

      final index = transactions.indexWhere((wallet) => wallet.id == event.newTrans.id);
      if (index != -1) {
        transactions[index] = event.newTrans;
        await DatabaseHelper().updateTransaction(event.newTrans);
        emit(TransactionChangedState(List.from(transactions)));
      } else {
        throw Exception('Category not found');
      }
    });

    on<RemoveTransactionEvent>((event, emit) async {
      final updatedTransactions = List<TransactionModel>.from(transactions)
        ..removeWhere((transaction) => transaction.id == event.newTrans.id);
      await DatabaseHelper().deleteTransaction(event.newTrans.id!);
      emit(TransactionChangedState(updatedTransactions));
    });
  }
}
