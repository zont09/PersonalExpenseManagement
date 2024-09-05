class Budget {
  int? id;
  late DateTime date;

  Budget({this.id, required this.date});

  factory Budget.fromMap(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'date': date,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}