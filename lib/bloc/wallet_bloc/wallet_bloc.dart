import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_event.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_state.dart';
import 'package:personal_expense_management/Model/Wallet.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final List<Wallet> wallets;

  WalletBloc(this.wallets) : super(wallets.isNotEmpty
      ? WalletSelectedState(wallets.first) // Chọn ví mặc định là ví đầu tiên
      : WalletInitialState()) {

    on<SelectWalletEvent>((event, emit) {
      final selectedWallet = wallets.firstWhere(
            (wallet) => wallet.id == event.walletId,
        orElse: () => throw Exception("No wallet found with id ${event.walletId}"),
      );
      emit(WalletSelectedState(selectedWallet));
    });
  }
}