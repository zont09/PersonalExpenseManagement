import 'package:personal_expense_management/Model/RepeatOption.dart';

class Reminder {
  int? id;
  DateTime date;
  String description;
  RepeatOption repeat_type;

  Reminder({this.id, required this.date, required this.description, required this.repeat_type});

  factory Reminder.fromMap(Map<String, dynamic> json, RepeatOption Rep) {
    return Reminder(
      id: json['id'],
      date: json['date'],
      description: json['description'],
      repeat_type: Rep,
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'date': date,
      'description': description,
      'repeat_type': repeat_type,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}