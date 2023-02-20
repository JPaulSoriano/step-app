import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:step/models/room_model.dart';

class AnnouncementDetailScreen extends StatefulWidget {
  final Announcement announcement;

  AnnouncementDetailScreen({required this.announcement});

  @override
  _AnnouncementDetailScreenState createState() =>
      _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState extends State<AnnouncementDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.announcement.title?.isEmpty ?? true
              ? 'No Title'
              : widget.announcement.title!,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.announcement.title?.isEmpty ?? true
                    ? 'No Title'
                    : widget.announcement.title!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '${DateFormat.yMMMMd().format(DateTime.parse(widget.announcement.created!))}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Html(data: widget.announcement.body!),
            ],
          ),
        ),
      ),
    );
  }
}
