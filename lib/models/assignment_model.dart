class Assignment {
  int? id;
  String? title;
  int? points;
  int? allowed_submission;
  String? due_date;
  String? instructions;
  String? url;
  String? file;

  Assignment({
    this.id,
    this.title,
    this.points,
    this.allowed_submission,
    this.due_date,
    this.instructions,
    this.url,
    this.file,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'],
      title: json['title'],
      points: json['points'],
      allowed_submission: json['allowed_submission'],
      due_date: json['due_date'],
      instructions: json['instructions'],
      url: json['url'],
      file: json['file'],
    );
  }
}
