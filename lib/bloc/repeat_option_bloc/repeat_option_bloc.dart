import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Model/Category.dart';
import 'package:personal_expense_management/Model/RepeatOption.dart';
import 'package:personal_expense_management/bloc/category_bloc/category_event.dart';
import 'package:personal_expense_management/bloc/category_bloc/category_state.dart';
import 'package:personal_expense_management/bloc/repeat_option_bloc/repeat_option_event.dart';
import 'package:personal_expense_management/bloc/repeat_option_bloc/repeat_option_state.dart';

class RepeatOptionBloc extends Bloc<RepeatOptionEvent, RepeatOptionState> {
  final List<RepeatOption> repeat_options;

  RepeatOptionBloc(this.repeat_options) : super(RepeatOptionUpdateState(repeat_options)) {
    on<AddRepeatOptionEvent>((event, emit) async {
      int id = await DatabaseHelper().insertRepeatOption(event.newRep);
      RepeatOption newRepOp = RepeatOption(id: id, option_name: event.newRep.option_name);
      repeat_options.add(newRepOp);
      emit(RepeatOptionUpdateState(List.from(repeat_options)));
    });

    on<UpdateRepeatOptionEvent>((event, emit) async {
      final index = repeat_options.indexWhere((wallet) => wallet.id == event.updRep.id);
      if (index != -1) {
        repeat_options[index] = event.updRep;
        await DatabaseHelper().updateRepeatOption(event.updRep);
        emit(RepeatOptionUpdateState(List.from(repeat_options)));
      } else {
        throw Exception('Category not found');
      }
    });

    on<RemoveRepeatOptionEvent>((event, emit) async {
      repeat_options.removeWhere((wallet) => wallet.id == event.remRep.id);
      await DatabaseHelper().deleteRepeatOption(event.remRep.id!);
      emit(RepeatOptionUpdateState(List.from(repeat_options)));
    });
  }
}