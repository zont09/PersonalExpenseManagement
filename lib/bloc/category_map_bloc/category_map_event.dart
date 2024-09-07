abstract class CategoryMapEvent {}

class UpdateCategoryMapEvent extends CategoryMapEvent {
  final Map<String, bool> mapIncome;
  final Map<String, bool> mapOutcome;

  UpdateCategoryMapEvent(this.mapIncome, this.mapOutcome);
}