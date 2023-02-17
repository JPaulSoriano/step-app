import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step/constant.dart';
import 'package:step/models/api_response.dart';
import 'package:step/models/user_model.dart';

// Login user with email and password
Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(loginURL),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password});

    switch (response.statusCode) {
      case 200:
        // If the response status code is 200, convert the response body to a User object and set it as the response data
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        // If the response status code is 422, get the errors object from the response body and set the first error message as the response error
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        // If the response status code is 403, set the response error to the message from the response body
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        // If the response status code is not 200, 422 or 403, set the response error to something went wrong
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    // If there's an error while making the request, set the response error to server error
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// Get user details
Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(userURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        // If the response status code is 200, convert the response body to a User object and set it as the response data
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 401:
        // If the response status code is 401, set the response error to unauthorized
        apiResponse.error = unauthorized;
        break;
      default:
        // If the response status code is not 200 or 401, set the response error to something went wrong
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    // If there's an error while making the request, set the response error to server error
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Get token from shared preferences
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// Get user id from shared preferences
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

// Logout user by removing token from shared preferences
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}
