import 'package:personal_expense_management/Model/Parameter.dart';

abstract class ParameterState {}

class ParameterInitialState extends ParameterState {}

class ParameterUpdateState extends ParameterState {
  final Parameter updPar;

  ParameterUpdateState(this.updPar);
}