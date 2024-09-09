import 'package:personal_expense_management/Model/RepeatOption.dart';

abstract class RepeatOptionState {}

class RepeatOptionInitialState extends RepeatOptionState {}

class RepeatOptionUpdateState extends RepeatOptionState {
  final List<RepeatOption> updRep;

  RepeatOptionUpdateState(this.updRep);
}