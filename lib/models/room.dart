class Room {
  int? id;
  String? name;
  String? section;
  String? key;

  Room({this.id, this.name, this.section, this.key});

  // function to convert json data to user model
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      section: json['section'],
      key: json['key'],
    );
  }
}
