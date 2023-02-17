import 'package:flutter/material.dart';
import 'package:step/constant.dart';
import 'package:step/models/api_response.dart';
import 'package:step/screens/home_screen.dart';
import 'package:step/services/user_service.dart';
import 'login_screen.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  // Method to load user info
  void _loadUserInfo() async {
    String token = await getToken();
    if (token == '') {
      // If token is empty, redirect to Login page
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()), (route) => false);
    } else {
      // Call getUserDetail API to get user info
      ApiResponse response = await getUserDetail();
      if (response.error == null) {
        // If user info is retrieved successfully, redirect to Home page
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      } else if (response.error == unauthorized) {
        // If user is not authorized, redirect to Login page
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()), (route) => false);
      } else {
        // If there's an error, show error message in SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      }
    }
  }

  // Call _loadUserInfo method on initialization
  @override
  void initState() {
    _loadUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
