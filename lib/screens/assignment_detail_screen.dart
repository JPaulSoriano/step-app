import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:step/models/room_model.dart';

class AssignmentDetailScreen extends StatefulWidget {
  final Assignment assignment;
  const AssignmentDetailScreen({super.key, required this.assignment});

  @override
  State<AssignmentDetailScreen> createState() => _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState extends State<AssignmentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 2,
        title: Text(widget.assignment.title?.isEmpty ?? true
            ? 'No Title'
            : widget.assignment.title!),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.assignment.title?.isEmpty ?? true
                    ? 'No Title'
                    : widget.assignment.title!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Due ${DateFormat.yMMMMd().format(DateTime.parse(widget.assignment.due_date!))}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                'Points: ${widget.assignment.points.toString()}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                'Allowed Resubmission: ${widget.assignment.allowed_submission.toString()}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Divider(color: Colors.grey),
              Text(
                widget.assignment.instructions!,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 24),
              Text(
                'Attachements',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              OutlinedButton(
                onPressed: () {
                  _downloadFile(widget.assignment.url!);
                },
                child: Text(widget.assignment.file!),
              ),
            ],
          ),
        ),
      ),
    );
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
