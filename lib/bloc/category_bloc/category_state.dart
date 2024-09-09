import 'package:personal_expense_management/Model/Category.dart';

abstract class CategoryState {}

class CategoryInitialState extends CategoryState {}

class CategoryUpdateState extends CategoryState {
  final List<Category> updCategory;

  CategoryUpdateState(this.updCategory);
}