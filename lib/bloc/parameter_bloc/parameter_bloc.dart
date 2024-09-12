import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Model/Category.dart';
import 'package:personal_expense_management/Model/Parameter.dart';
import 'package:personal_expense_management/Model/RepeatOption.dart';
import 'package:personal_expense_management/bloc/category_bloc/category_event.dart';
import 'package:personal_expense_management/bloc/category_bloc/category_state.dart';
import 'package:personal_expense_management/bloc/parameter_bloc/parameter_event.dart';
import 'package:personal_expense_management/bloc/parameter_bloc/parameter_state.dart';
import 'package:personal_expense_management/bloc/repeat_option_bloc/repeat_option_event.dart';
import 'package:personal_expense_management/bloc/repeat_option_bloc/repeat_option_state.dart';

class ParameterBloc extends Bloc<ParameterEvent, ParameterState> {
  Parameter parameters;

  ParameterBloc(this.parameters) : super(ParameterUpdateState(parameters)) {
    on<AddParameterEvent>((event, emit) async {
      parameters = event.newPar;
      DatabaseHelper().insertParameter(event.newPar);
      emit(ParameterUpdateState(event.newPar));
    });

    on<UpdateParameterEvent>((event, emit) async {
        await DatabaseHelper().deleteAllParameters();
        await DatabaseHelper().insertParameter(event.updPar);
        emit(ParameterUpdateState(event.updPar));

    });
  }
}