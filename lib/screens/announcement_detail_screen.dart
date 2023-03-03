import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:step/constant.dart';
import 'package:step/models/announcement_model.dart';
import 'package:step/models/api_response.dart';
import 'package:step/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:step/services/user_service.dart';

class AnnouncementDetailScreen extends StatefulWidget {
  final Announcement announcement;

  AnnouncementDetailScreen({required this.announcement});

  @override
  _AnnouncementDetailScreenState createState() =>
      _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState extends State<AnnouncementDetailScreen> {
  TextEditingController _txtCommentController = TextEditingController();
  bool _loading = true;

  Future<ApiResponse> createComment(int postId, String? body) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      String token = await getToken();
      final response = await http.post(
          Uri.parse('${CommentUrl}/${widget.announcement.id}/comment'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: {
            'body': body
          });

      switch (response.statusCode) {
        case 200:
          apiResponse.data = jsonDecode(response.body);
          break;
        case 403:
          apiResponse.error = jsonDecode(response.body)['message'];
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      print(e);
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

  // create comment
  void _createComment() async {
    ApiResponse response = await createComment(
        widget.announcement.id ?? 0, _txtCommentController.text);

    if (response.error == null) {
      _txtCommentController.clear();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

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
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: kInputDecoration('Comment'),
                  controller: _txtCommentController,
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (_txtCommentController.text.isNotEmpty) {
                    setState(() {
                      _loading = true;
                    });
                    _createComment();
                  }
                },
              )
            ],
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
