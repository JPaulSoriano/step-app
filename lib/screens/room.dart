import 'package:flutter/material.dart';
import 'package:step/constant.dart';
import 'package:step/models/api_response.dart';
import 'package:step/models/room.dart';
import 'package:step/services/room_service.dart';
import 'package:step/services/user_service.dart';
import 'login.dart';

class RoomScreen extends StatefulWidget {
  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  List<dynamic> _roomList = [];
  int userId = 0;
  bool _loading = true;

  // get all rooms
  Future<void> retrieveRooms() async {
    userId = await getUserId();
    ApiResponse response = await getRooms();

    if (response.error == null) {
      setState(() {
        _roomList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  @override
  void initState() {
    retrieveRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () {
              return retrieveRooms();
            },
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // number of columns
                childAspectRatio: 1, // square cards
              ),
              itemCount: _roomList.length,
              itemBuilder: (BuildContext context, int index) {
                Room room = _roomList[index];
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${room.name}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${room.section}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                      Text(
                        '${room.key}',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.normal),
                      )
                    ],
                  ),
                );
              },
            ));
  }
}
