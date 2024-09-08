import 'package:personal_expense_management/Model/Wallet.dart';

abstract class WalletEvent {}

class AddWalletEvent extends WalletEvent {
  final Wallet wallet;

  AddWalletEvent(this.wallet);
}

class UpdateWalletEvent extends WalletEvent {
  final Wallet wallet;

  UpdateWalletEvent(this.wallet);
}

class RemoveWalletEvent extends WalletEvent {
  final Wallet wallet;

  RemoveWalletEvent(this.wallet);
}
