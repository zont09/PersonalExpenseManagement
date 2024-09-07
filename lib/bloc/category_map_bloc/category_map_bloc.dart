import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/bloc/category_map_bloc/category_map_event.dart';
import 'package:personal_expense_management/bloc/category_map_bloc/category_map_state.dart';

class CategoryMapBloc extends Bloc<CategoryMapEvent, CategoryMapState> {
  CategoryMapBloc(Map<String, bool> initialMapIncome, Map<String, bool> initialMapOutcome)
      : super(CategoryMapUpdatedState(initialMapIncome, initialMapOutcome)) {
    on<UpdateCategoryMapEvent>((event, emit) {
      emit(CategoryMapUpdatedState(event.mapIncome, event.mapOutcome));
    });
  }
}