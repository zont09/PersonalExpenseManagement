import 'package:personal_expense_management/Model/Parameter.dart';
import 'package:personal_expense_management/Model/RepeatOption.dart';

abstract class ParameterEvent {}

class AddParameterEvent extends ParameterEvent {
  final Parameter newPar;

  AddParameterEvent(this.newPar);
}

class UpdateParameterEvent extends ParameterEvent {
  final Parameter updPar;

  UpdateParameterEvent(this.updPar);
}
