import 'package:flutter/material.dart';
import 'package:step/screens/join_screen.dart';
import 'package:step/screens/notification_screen.dart';
import 'package:step/screens/profile_screen.dart';
import 'package:step/screens/room_screen.dart';
import 'package:step/services/user_service.dart';
import 'login_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    RoomScreen(),
    Profile(),
    NotificationsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step S'),
        elevation: 0,
        scrolledUnderElevation: 2,
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
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      // Add a floating action button to the screen
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Display a dialog to join a new room
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JoinRoomForm(),
              ));
        },
        child: Icon(Icons.add),
      ),
      // Add a bottom app bar with a BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Room',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
