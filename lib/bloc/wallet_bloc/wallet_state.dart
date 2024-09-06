import 'package:personal_expense_management/Model/Wallet.dart';

abstract class WalletState {}

class WalletInitialState extends WalletState {}

class WalletSelectedState extends WalletState {
  final Wallet selectedWallet;

  WalletSelectedState(this.selectedWallet);
}