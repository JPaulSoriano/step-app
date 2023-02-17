// Main function to run the app
import 'package:flutter/material.dart';
import 'screens/loading.dart';

void main() {
  runApp(App());
}

// App class to build and return the MaterialApp widget
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide the debug banner
      home: Loading(), // Set the initial route of the app to Loading screen
    );
  }
}
