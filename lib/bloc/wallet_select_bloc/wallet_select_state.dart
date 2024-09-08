import 'package:personal_expense_management/Model/Wallet.dart';

abstract class WalletSelectState {}

class WalletInitialState extends WalletSelectState {}

class WalletSelectedState extends WalletSelectState {
  final Wallet selectedWallet;

  WalletSelectedState(this.selectedWallet);
}