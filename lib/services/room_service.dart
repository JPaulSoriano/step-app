import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:step/constant.dart';
import 'package:step/models/api_response.dart';
import 'package:step/models/room_model.dart';
import 'package:step/services/user_service.dart';

// get all rooms
Future<ApiResponse> getRooms() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(roomURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    // check response status code
    switch (response.statusCode) {
      case 200:
        // convert response body to json and then map it to list of rooms
        apiResponse.data = jsonDecode(response.body)['data']
            .map((p) => Room.fromJson(p))
            .toList();

        apiResponse.data as List<dynamic>;
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

// Join a room
Future<ApiResponse> joinRoom(String roomKey) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(joinRoomURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'key': roomKey,
    });

    // check response status code
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['data'];
        break;
      case 400:
        apiResponse.error = jsonDecode(response.body)['error'];
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
