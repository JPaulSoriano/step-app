import 'package:flutter/material.dart';
import 'package:step/screens/join.dart';
import 'package:step/screens/profile.dart';
import 'package:step/screens/room.dart';
import 'package:step/services/user_service.dart';
import 'login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step S'),

        // Add a logout button to the app bar
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              logout().then((value) => {
                    // Navigate to the Login screen and remove all previous screens
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Login()),
                        (route) => false)
                  });
            },
          )
        ],
      ),

      // Display either the RoomScreen or Profile widget based on the current index
      body: currentIndex == 0 ? RoomScreen() : Profile(),

      // Add a floating action button to the screen
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Display a dialog to join a new room
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return JoinRoomForm();
            },
          );
        },
        child: Icon(Icons.add),
      ),

      // Add a bottom app bar with a BottomNavigationBar
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5,
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.meeting_room), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '')
          ],
          currentIndex: currentIndex,
          onTap: (val) {
            // Update the current index based on the tapped item
            setState(() {
              currentIndex = val;
            });
          },
        ),
      ),
    );
  }
}
