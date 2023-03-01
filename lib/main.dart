// Main function to run the app
import 'package:flutter/material.dart';
import 'screens/loading_screen.dart';

void main() {
  runApp(App());
}

// App class to build and return the MaterialApp widget
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.blueGrey,
          primary: Colors.blueGrey,
        ),
        textTheme:
            const TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
      ),
      debugShowCheckedModeBanner: false, // Hide the debug banner
      home: Loading(), // Set the initial route of the app to Loading screen
    );
  }
}
