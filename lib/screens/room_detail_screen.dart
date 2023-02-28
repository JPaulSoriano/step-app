import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:step/models/room_model.dart';
import 'package:http/http.dart' as http;
import 'package:step/screens/announcement_detail_screen.dart';
import 'package:step/screens/assignment_detail_screen.dart';

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
        actions: [
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {},
          ),
        ],
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
      body: Column(
        children: [
          Card(
            color: Colors.grey[300],
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  widget.room.section!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.room.teacher!),
                    Text(widget.room.key!),
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
            icon: Icon(Icons.assessment),
            label: 'Assessments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_document),
            label: 'Materials',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assignments',
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
      case 2:
        return _buildMaterials();
      case 3:
        return _buildAssignments();
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
            elevation: 0,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AnnouncementDetailScreen(announcement: announcement),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      announcement.title?.isEmpty ?? true
                          ? 'No Title'
                          : announcement.title!,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${DateFormat.yMMMMd().format(DateTime.parse(announcement.created!))}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildAssessments() {
    if (widget.room.assessments!.isEmpty) {
      return Center(child: Text('No assessments'));
    } else {
      return ListView.builder(
        itemCount: widget.room.assessments!.length,
        itemBuilder: (context, index) {
          final assessment = widget.room.assessments![index];
          return Card(
            elevation: 0,
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
                  Text(
                    'Status: ${assessment.status}',
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildMaterials() {
    if (widget.room.materials!.isEmpty) {
      return Center(child: Text('No materials'));
    } else {
      return ListView.builder(
        itemCount: widget.room.materials!.length,
        itemBuilder: (context, index) {
          final material = widget.room.materials![index];
          return Card(
            elevation: 0,
            child: InkWell(
              onTap: () {
                _downloadFile(material.url!);
              },
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      material.title!,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      material.description!,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildAssignments() {
    if (widget.room.assignments!.isEmpty) {
      return Center(child: Text('No assignments'));
    } else {
      return ListView.builder(
        itemCount: widget.room.assignments!.length,
        itemBuilder: (context, index) {
          final assignment = widget.room.assignments![index];
          return Card(
            elevation: 0,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AssignmentDetailScreen(assignment: assignment),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      assignment.title!,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Due Date: ${DateFormat.yMMMMd().format(DateTime.parse(assignment.due_date!))}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> _downloadFile(String url) async {
    final response = await http.get(Uri.parse(url));

    final fileName = url.split('/').last;
    final downloadsDir = Directory('/storage/emulated/0/Download');
    await downloadsDir.create(recursive: true);
    final filePath = '${downloadsDir.path}/$fileName';
    final file = File(filePath);

    await file.writeAsBytes(response.bodyBytes);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File downloaded to ${file.path}'),
      ),
    );
  }
}
