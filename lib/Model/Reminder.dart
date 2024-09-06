import 'package:personal_expense_management/Model/RepeatOption.dart';

class Reminder {
  int? id;
  String date;
  String description;
  RepeatOption repeat_option;

  Reminder({this.id, required this.date, required this.description, required this.repeat_option});

  factory Reminder.fromMap(Map<String, dynamic> json, RepeatOption Rep) {
    return Reminder(
      id: json['id'],
      date: json['date'],
      description: json['description'],
      repeat_option: Rep,
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'date': date,
      'description': description,
      'repeat_option': repeat_option.id,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}