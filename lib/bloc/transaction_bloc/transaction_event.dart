import 'package:personal_expense_management/Model/TransactionModel.dart';

abstract class TransactionEvent {}

class AddTransactionEvent extends TransactionEvent {
  final TransactionModel newTrans;

  AddTransactionEvent(this.newTrans);
}

class RemoveTransactionEvent extends TransactionEvent {
  final TransactionModel newTrans;

  RemoveTransactionEvent(this.newTrans);
}

class UpdateTransactionEvent extends TransactionEvent {
  final TransactionModel newTrans;

  UpdateTransactionEvent(this.newTrans);
}
