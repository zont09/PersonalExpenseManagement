import 'package:personal_expense_management/Model/TransactionModel.dart';

abstract class TransactionState {}

class TransactionInitialState extends TransactionState {

}
class TransactionChangedState extends TransactionState {
  final List<TransactionModel> newTransaction;

  TransactionChangedState(this.newTransaction);
}