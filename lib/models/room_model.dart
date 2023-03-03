import 'package:step/models/announcement_model.dart';
import 'package:step/models/assessment_model.dart';
import 'package:step/models/material_model.dart';
import 'assignment_model.dart';

class Room {
  int? id;
  String? name;
  String? section;
  String? key;
  String? schedule;
  String? teacher;
  String? vc_link;
  List<Announcement>? announcements;
  List<Assessment>? assessments;
  List<Material>? materials;
  List<Assignment>? assignments;

  Room({
    this.id,
    this.name,
    this.section,
    this.key,
    this.schedule,
    this.teacher,
    this.vc_link,
    this.announcements,
    this.assessments,
    this.materials,
    this.assignments,
  });

  // function to convert json data to user model
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      section: json['section'],
      key: json['key'],
      teacher: json['teacher']['full_name'],
      vc_link: json['vc_link'],
      schedule: json['schedule'],
      announcements: (json['announcements'] as List<dynamic>)
          .map((e) => Announcement.fromJson(e))
          .toList(),
      assessments: (json['assessments'] as List<dynamic>)
          .map((e) => Assessment.fromJson(e))
          .toList(),
      materials: (json['materials'] as List<dynamic>)
          .map((e) => Material.fromJson(e))
          .toList(),
      assignments: (json['assignments'] as List<dynamic>)
          .map((e) => Assignment.fromJson(e))
          .toList(),
    );
  }
}
