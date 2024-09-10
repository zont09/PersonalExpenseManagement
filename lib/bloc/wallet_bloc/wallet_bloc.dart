import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_event.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_state.dart';
import 'package:personal_expense_management/Model/Wallet.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final List<Wallet> wallets;

  WalletBloc(this.wallets) : super(WalletUpdatedState(wallets)) {

    on<AddWalletEvent>((event, emit) async {
      wallets.add(event.wallet);
      DatabaseHelper().insertWallet(event.wallet);
      emit(WalletUpdatedState(List.from(wallets)));
    });

    on<UpdateWalletEvent>((event, emit) async {
      print("IS CALL ????");
      final index = wallets.indexWhere((wallet) => wallet.id == event.wallet.id);
      if (index != -1) {
        wallets[index] = event.wallet;
        await DatabaseHelper().updateWallet(event.wallet);
        emit(WalletUpdatedState(List.from(wallets)));
      } else {
        throw Exception('Wallet not found');
      }
    });

    // on<RemoveWalletEvent>((event, emit) async {
    //   wallets.removeWhere((wallet) => wallet.id == event.wallet.id);
    //   await DatabaseHelper().deleteWallet(event.wallet.id!);
    //   emit(WalletUpdatedState(List.from(wallets)));
    // });
  }
}