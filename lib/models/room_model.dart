class Room {
  int? id;
  String? name;
  String? section;
  String? key;
  String? schedule;
  List<Announcement>? announcements;
  List<Assessment>? assessments;

  Room({
    this.id,
    this.name,
    this.section,
    this.key,
    this.schedule,
    this.announcements,
    this.assessments,
  });

  // function to convert json data to user model
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      section: json['section'],
      key: json['key'],
      schedule: json['schedule'],
      announcements: (json['announcements'] as List<dynamic>)
          .map((e) => Announcement.fromJson(e))
          .toList(),
      assessments: (json['assessments'] as List<dynamic>)
          .map((e) => Assessment.fromJson(e))
          .toList(),
    );
  }
}

class Announcement {
  int? id;
  String? title;
  String? body;
  String? created;

  Announcement({
    this.id,
    this.title,
    this.body,
    this.created,
  });

  // function to convert json data to announcement model
  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      created: json['created_at'],
    );
  }
}

class Assessment {
  int? id;
  String? title;
  int? duration;
  int? items;
  String? startDate;
  String? endDate;

  Assessment({
    this.id,
    this.title,
    this.duration,
    this.items,
    this.startDate,
    this.endDate,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
        id: json['id'],
        title: json['title'],
        duration: json['duration'],
        items: json['items'],
        startDate: json['assessment_dates'][0]['start_date'],
        endDate: json['assessment_dates'][0]['end_date']);
  }
}
