class Category {
  int? id;
  late String name;
  late int type;

  Category({this.id, required this.name, required this.type});

  factory Category.fromMap(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'name': name,
      'type': type,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}