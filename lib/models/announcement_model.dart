import 'package:step/models/comment_model.dart';

class Announcement {
  int? id;
  String? title;
  String? body;
  String? created;
  List<Comment>? comments;

  Announcement({
    this.id,
    this.title,
    this.body,
    this.created,
    this.comments,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      created: json['created_at'],
      comments: (json['comments'] as List<dynamic>)
          .map((e) => Comment.fromJson(e))
          .toList(),
    );
  }
}
