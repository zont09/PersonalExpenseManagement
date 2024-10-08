import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_event.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_state.dart';
import 'package:personal_expense_management/Model/Wallet.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final List<Wallet> wallets;

  WalletBloc(this.wallets) : super(WalletUpdatedState(wallets)) {

    on<AddWalletEvent>((event, emit) async {
      int id = await DatabaseHelper().insertWallet(event.wallet);
      Wallet newWal = Wallet(id: id, name: event.wallet.name, amount: event.wallet.amount, currency: event.wallet.currency, note: event.wallet.note);
      wallets.add(newWal);
      emit(WalletUpdatedState(List.from(wallets)));
    });

    on<UpdateWalletEvent>((event, emit) async {
      final index = wallets.indexWhere((wallet) => wallet.id == event.wallet.id);
      if (index != -1) {
        final amountDiff = event.wallet.amount - wallets[index].amount;
        wallets[index] = event.wallet;
        if(event.wallet.id != 0 ) {
          wallets[0].amount += (amountDiff * event.wallet.currency.value);
          await DatabaseHelper().updateWallet(wallets[0]);
        }
        await DatabaseHelper().updateWallet(event.wallet);
        emit(WalletUpdatedState(List.from(wallets)));
      } else {
        throw Exception('Wallet not found');
      }
    });

    on<RemoveWalletEvent>((event, emit) async {
      wallets.removeWhere((wallet) => wallet.id == event.wallet.id);
      await DatabaseHelper().deleteWallet(event.wallet.id!);
      emit(WalletUpdatedState(List.from(wallets)));
    });
  }
}