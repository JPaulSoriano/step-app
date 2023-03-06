import 'package:step/models/comment_model.dart';

class Announcement {
  int? id;
  String? title;
  String? body;
  String? created;
  String? user;
  List<Comment>? comments;

  Announcement({
    this.id,
    this.title,
    this.body,
    this.created,
    this.user,
    this.comments,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      created: json['created_at'],
      user: json['user']['full_name'],
      comments: (json['comments'] as List<dynamic>)
          .map((e) => Comment.fromJson(e))
          .toList(),
    );
  }
  int get commentCount => comments?.length ?? 0;
}
