class Saving {
  int? id;
  String name;
  double target_amount;
  DateTime target_date;
  double current_amount;
  bool is_finished;

  Saving({this.id, required this.name, required this.target_amount, required this.target_date, required this.current_amount, required this.is_finished});
  factory Saving.fromMap(Map<String, dynamic> json) {
    return Saving(
      id: json['id'],
      name: json['name'],
      target_amount: json['target_amount'],
      target_date: json['target_date'],
      current_amount: json['current_amount'],
      is_finished: json['is_finished'],
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'name': name,
      'target_amount': target_amount,
      'target_date': target_date,
      'current_amount': current_amount,
      'is_finished': is_finished
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}