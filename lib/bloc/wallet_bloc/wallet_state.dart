import 'package:personal_expense_management/Model/Wallet.dart';

abstract class WalletState {}

class WalletInitialState extends WalletState {}

class WalletUpdatedState extends WalletState {
  final List<Wallet> updatedWallet;

  WalletUpdatedState(this.updatedWallet);
}