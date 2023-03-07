// Get post comments
import 'dart:convert';

import 'package:step/constant.dart';
import 'package:step/models/api_response.dart';
import 'package:step/models/comment_model.dart';
import 'package:step/services/user_service.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getComments(int announcementID) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .get(Uri.parse('$CommentUrl/$announcementID/comments'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        // map each comments to comment model
        apiResponse.data = jsonDecode(response.body)['comments']
            .map((p) => Comment.fromJson(p))
            .toList();
        apiResponse.data as List<dynamic>;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print('Request failed with status: ${response.statusCode}.');
        print('Response body: ${response.body}');
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Create comment
Future<ApiResponse> createComment(int announcementID, String? body) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .post(Uri.parse('$CommentUrl/$announcementID/comment'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
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
        print('Request failed with status: ${response.statusCode}.');
        print('Response body: ${response.body}');
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}