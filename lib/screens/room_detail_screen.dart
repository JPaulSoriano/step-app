import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:step/models/room_model.dart';

class RoomDetailScreen extends StatefulWidget {
  final Room room;

  const RoomDetailScreen({Key? key, required this.room}) : super(key: key);

  @override
  _RoomDetailScreenState createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name!),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Announcements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assessments',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildAnnouncements();
      case 1:
        return _buildAssessments();
      default:
        return Container();
    }
  }

  Widget _buildAnnouncements() {
    if (widget.room.announcements!.isEmpty) {
      return Center(child: Text('No announcements'));
    } else {
      return ListView.builder(
        itemCount: widget.room.announcements!.length,
        itemBuilder: (context, index) {
          final announcement = widget.room.announcements![index];
          return Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    announcement.title?.isEmpty ?? true
                        ? 'No Title'
                        : announcement.title!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${DateFormat.yMMMMd().format(DateTime.parse(announcement.created!))}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Html(
                    data: announcement.body!,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildAssessments() {
    if (widget.room.assessments!.isEmpty) {
      return Center(child: Text('No announcements'));
    } else {
      return ListView.builder(
        itemCount: widget.room.assessments!.length,
        itemBuilder: (context, index) {
          final assessment = widget.room.assessments![index];
          return Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    assessment.title!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Duration: ${assessment.duration.toString()}',
                  ),
                  Text(
                    'Items: ${assessment.items.toString()}',
                  ),
                  Text(
                    'Start Date: ${assessment.startDate}',
                  ),
                  Text(
                    'End Date: ${assessment.endDate}',
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
