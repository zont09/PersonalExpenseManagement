import 'package:personal_expense_management/Model/Category.dart';

abstract class CategoryEvent {}

class AddCategoryEvent extends CategoryEvent {
  final Category newCat;

  AddCategoryEvent(this.newCat);
}

class UpdateCategoryEvent extends CategoryEvent {
  final Category updCat;

  UpdateCategoryEvent(this.updCat);
}

class RemoveCategoryEvent extends CategoryEvent {
  final Category remCat;

  RemoveCategoryEvent(this.remCat);
}