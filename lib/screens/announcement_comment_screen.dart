import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:step/constant.dart';
import 'package:step/models/announcement_model.dart';
import 'package:step/models/api_response.dart';
import 'package:step/screens/login_screen.dart';
import 'package:step/services/user_service.dart';
import 'package:http/http.dart' as http;

class AnnouncementCommentScreen extends StatefulWidget {
  final Announcement announcement;

  AnnouncementCommentScreen({required this.announcement});

  @override
  _AnnouncementCommentScreenState createState() =>
      _AnnouncementCommentScreenState();
}

class _AnnouncementCommentScreenState extends State<AnnouncementCommentScreen> {
  TextEditingController _txtCommentController = TextEditingController();
  Future<ApiResponse> createComment(String? body) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      String token = await getToken();
      final response = await http.post(
          Uri.parse('$CommentUrl/${widget.announcement.id}/comment'),
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
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

  // create comment
  void _createComment() async {
    ApiResponse response = await createComment(_txtCommentController.text);
    if (response.error == null) {
      _txtCommentController.clear();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
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
          Expanded(
            child: SingleChildScrollView(
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
                        return Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.black26, width: 0.5))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        widget.announcement.comments![index]
                                            .user!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        '${DateFormat.yMMMMd().format(DateTime.parse(widget.announcement.comments![index].created!))}',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                widget.announcement.comments![index].body!,
                              )
                            ],
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
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Colors.black26, width: 0.5)),
            ),
            child: Row(
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
                      _createComment();
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
