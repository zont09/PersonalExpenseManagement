import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Model/TransactionModel.dart';
import 'package:personal_expense_management/bloc/transaction_bloc/transaction_event.dart';
import 'package:personal_expense_management/bloc/transaction_bloc/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final List<TransactionModel> transactions;

  TransactionBloc(this.transactions) : super(TransactionChangedState(transactions)) {

    on<AddTransactionEvent>((event, emit) async {
      final updatedTransactions = List<TransactionModel>.from(transactions)
        ..add(event.newTrans);
      await DatabaseHelper().insertTransaction(event.newTrans);
      emit(TransactionChangedState(updatedTransactions));
    });

    on<UpdateTransactionEvent>((event, emit) async {
      final updatedTransactions = List<TransactionModel>.from(transactions)
        ..removeWhere((transaction) => transaction.id == event.newTrans.id)
        ..add(event.newTrans);
      await DatabaseHelper().updateTransaction(event.newTrans);
      emit(TransactionChangedState(updatedTransactions));
    });

    on<RemoveTransactionEvent>((event, emit) async {
      final updatedTransactions = List<TransactionModel>.from(transactions)
        ..removeWhere((transaction) => transaction.id == event.newTrans.id);
      await DatabaseHelper().deleteTransaction(event.newTrans.id!);
      emit(TransactionChangedState(updatedTransactions));
    });
  }
}