import 'package:flutter/material.dart';
import 'package:step/constant.dart';
import 'package:step/models/api_response.dart';
import 'package:step/models/room_model.dart';
import 'package:step/screens/room_detail_screen.dart';
import 'package:step/services/room_service.dart';
import 'package:step/services/user_service.dart';
import 'login_screen.dart';

class RoomScreen extends StatefulWidget {
  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  List<dynamic> _roomList = [];
  int userId = 0;
  bool _loading = true;

  @override
  void initState() {
    retrieveRooms(); // retrieve rooms on initialization
    super.initState();
  }

  // retrieve all rooms and update the state
  Future<void> retrieveRooms() async {
    userId = await getUserId();
    ApiResponse response = await getRooms();

    if (response.error == null) {
      setState(() {
        _roomList = response.data as List<dynamic>;
        _loading = false; // turn off loading indicator
      });
    } else if (response.error == unauthorized) {
      // handle unauthorized access by logging out and navigating to login page
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      // display error message in snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(
            child:
                CircularProgressIndicator()) // display loading indicator if rooms are still being retrieved
        : RefreshIndicator(
            onRefresh: () {
              return retrieveRooms(); // allow user to manually refresh list of rooms
            },
            child: ListView.builder(
              itemCount: _roomList.length,
              itemBuilder: (BuildContext context, int index) {
                Room room = _roomList[index];
                return GestureDetector(
                  // wrap the ListTile in a GestureDetector
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoomDetailScreen(
                            room:
                                room), // navigate to the RoomDetailScreen and pass the room data
                      ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListTile(
                        title: Text(
                          '${room.name}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${room.section}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.normal),
                            ),
                            Text(
                              '${room.key}',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal),
                            ),
                            Text(
                              room.schedule?.isEmpty ?? true
                                  ? 'Schedule not set by the teacher'
                                  : room.schedule!,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ));
  }
}
