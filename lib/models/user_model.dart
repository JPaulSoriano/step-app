class User {
  int? id;
  String? email;
  String? name;
  String? token;

  User({this.id, this.email, this.name, this.token});

  // function to convert json data to user model
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['user']['id'],
        email: json['user']['email'],
        name: json['user']['name'],
        token: json['token']);
  }
}
