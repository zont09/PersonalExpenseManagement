abstract class CategoryMapState {}

class CategoryMapInitialState extends CategoryMapState {}

class CategoryMapUpdatedState extends CategoryMapState {
  final Map<String, bool> mapIncome;
  final Map<String, bool> mapOutcome;

  CategoryMapUpdatedState(this.mapIncome, this.mapOutcome);
}