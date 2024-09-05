class RepeatOption {
  int? id;
  late String option_name;

  RepeatOption({this.id, required this.option_name});

  factory RepeatOption.fromMap(Map<String, dynamic> json) {
    return RepeatOption(
      id: json['id'],
      option_name: json['option_name'],
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'option_name': option_name,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}