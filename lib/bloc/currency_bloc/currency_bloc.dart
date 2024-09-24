import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Model/Budget.dart';
import 'package:personal_expense_management/Model/Currency.dart';
import 'package:personal_expense_management/bloc/currency_bloc/currency_event.dart';
import 'package:personal_expense_management/bloc/currency_bloc/currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final List<Currency> currencies;

  CurrencyBloc(this.currencies) : super(CurrencyUpdateState(currencies)) {
    on<AddCurrencyEvent>((event, emit) async {
      int id = await DatabaseHelper().insertCurrency(event.newCur);
      Currency updatedCurrency = Currency(id: id,name: event.newCur.name, value: event.newCur.value);
      currencies.add(updatedCurrency);
      emit(CurrencyUpdateState(List.from(currencies)));
    });

    on<UpdateCurrencyEvent>((event, emit) async {
      final index = currencies.indexWhere((wallet) => wallet.id == event.updCur.id);
      if (index != -1) {
        currencies[index] = event.updCur;
        await DatabaseHelper().updateCurrency(event.updCur);
        emit(CurrencyUpdateState(List.from(currencies)));
      } else {
        throw Exception('Currency not found');
      }
    });

    on<RemoveCurrencyEvent>((event, emit) async {
      currencies.removeWhere((wallet) => wallet.id == event.remCur.id);
      await DatabaseHelper().deleteCurrency(event.remCur.id!);
      emit(CurrencyUpdateState(List.from(currencies)));
    });
  }
}