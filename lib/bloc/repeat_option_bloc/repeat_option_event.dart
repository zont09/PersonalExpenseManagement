import 'package:personal_expense_management/Model/Category.dart';
import 'package:personal_expense_management/Model/RepeatOption.dart';

abstract class RepeatOptionEvent {}

class AddRepeatOptionEvent extends RepeatOptionEvent {
  final RepeatOption newRep;

  AddRepeatOptionEvent(this.newRep);
}

class UpdateRepeatOptionEvent extends RepeatOptionEvent {
  final RepeatOption updRep;

  UpdateRepeatOptionEvent(this.updRep);
}

class RemoveRepeatOptionEvent extends RepeatOptionEvent {
  final RepeatOption remRep;

  RemoveRepeatOptionEvent(this.remRep);
}