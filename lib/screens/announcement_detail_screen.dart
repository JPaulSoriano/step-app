import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:step/models/announcement_model.dart';

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
        elevation: 0,
        scrolledUnderElevation: 2,
        title: Text(widget.announcement.title?.isEmpty ?? true
            ? 'No Title'
            : widget.announcement.title!),
      ),
      body: Column(
        children: [
          Card(
            color: Colors.blueGrey[100],
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListTile(
                title: Text(
                  widget.announcement.title?.isEmpty ?? true
                      ? 'No Title'
                      : widget.announcement.title!,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${DateFormat.yMMMMd().format(DateTime.parse(widget.announcement.created!))}',
                        style: TextStyle(fontSize: 14)),
                    Html(
                      data: widget.announcement.body!,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 8),
                    if (widget.announcement.comments != null &&
                        widget.announcement.comments!.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.announcement.comments!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Row(
                              children: [
                                Text(
                                  widget.announcement.comments![index].user!,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '${DateFormat.yMMMMd().format(DateTime.parse(widget.announcement.comments![index].created!))}',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              widget.announcement.comments![index].body!,
                              style: TextStyle(
                                  fontSize: 10, color: Colors.grey[700]),
                            ),
                          );
                        },
                      ),
                    if (widget.announcement.comments == null ||
                        widget.announcement.comments!.isEmpty)
                      Text('No comments yet.'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
