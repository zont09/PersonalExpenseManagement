import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Model/Category.dart';
import 'package:personal_expense_management/bloc/category_bloc/category_event.dart';
import 'package:personal_expense_management/bloc/category_bloc/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final List<Category> categories;
  
  CategoryBloc(this.categories) : super(CategoryUpdateState(categories)) {
    on<AddCategoryEvent>((event, emit) async {
      categories.add(event.newCat);
      DatabaseHelper().insertCategory(event.newCat);
      emit(CategoryUpdateState(List.from(categories)));
    });

    on<UpdateCategoryEvent>((event, emit) async {
      final index = categories.indexWhere((wallet) => wallet.id == event.updCat.id);
      if (index != -1) {
        categories[index] = event.updCat;
        await DatabaseHelper().updateCategory(event.updCat);
        emit(CategoryUpdateState(List.from(categories)));
      } else {
        throw Exception('Category not found');
      }
    });

    on<RemoveCategoryEvent>((event, emit) async {
      categories.removeWhere((wallet) => wallet.id == event.remCat.id);
      await DatabaseHelper().deleteCategory(event.remCat.id!);
      emit(CategoryUpdateState(List.from(categories)));
    });
  }
}