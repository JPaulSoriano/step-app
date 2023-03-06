class User {
  int? id;
  String? email;
  String? name;
  String? avatar;
  String? token;

  User({this.id, this.email, this.name, this.avatar, this.token});

  // function to convert json data to user model
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['user']['id'],
        email: json['user']['email'],
        name: json['user']['name'],
        avatar: json['user']['avatar'],
        token: json['token']);
  }
}
