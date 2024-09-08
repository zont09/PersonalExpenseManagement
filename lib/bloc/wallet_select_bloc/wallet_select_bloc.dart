import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Model/Wallet.dart';
import 'package:personal_expense_management/bloc/wallet_select_bloc/wallet_select_event.dart';
import 'package:personal_expense_management/bloc/wallet_select_bloc/wallet_select_state.dart';

class WalletSelectBloc extends Bloc<WalletSelectEvent, WalletSelectState> {
  final List<Wallet> wallets;

  WalletSelectBloc(this.wallets) : super(wallets.isNotEmpty
      ? WalletSelectedState(wallets.first) // Chọn ví mặc định là ví đầu tiên
      : WalletInitialState()) {

    on<SelectedWalletEvent>((event, emit) {
      final selectedWallet = wallets.firstWhere(
            (wallet) => wallet.id == event.walletId,
        orElse: () => throw Exception("No wallet found with id ${event.walletId}"),
      );
      emit(WalletSelectedState(selectedWallet));
    });
  }
}