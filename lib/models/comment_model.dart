class Comment {
  int? id;
  String? body;
  String? created;
  String? user;
  String? avatar;

  Comment({this.id, this.body, this.created, this.user, this.avatar});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      body: json['body'],
      created: json['created_at'],
      user: json['user']['full_name'],
      avatar: json['user']['avatar'],
    );
  }
}
