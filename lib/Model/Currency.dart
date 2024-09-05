class Currency {
  int? id;
  late String name;
  late double value;

  Currency({this.id, required this.name, required this.value});

  factory Currency.fromMap(Map<String, dynamic> json) {
    return Currency(
        id: json['id'],
        name: json['name'],
        value: json['value'],
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'name': name,
      'value': value,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}