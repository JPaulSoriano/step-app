import 'package:flutter/material.dart';
import 'package:step/constant.dart';
import 'package:step/models/api_response.dart';
import 'package:step/screens/home.dart';
import 'package:step/services/room_service.dart';

class JoinRoomForm extends StatefulWidget {
  JoinRoomForm({Key? key}) : super(key: key);

  @override
  _JoinRoomFormState createState() => _JoinRoomFormState();
}

class _JoinRoomFormState extends State<JoinRoomForm> {
  final _formKey = GlobalKey<FormState>();
  String _roomKey = '';

  ApiResponse _apiResponse = ApiResponse();

  Future<void> _joinRoom() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Call the joinRoom function with the room key
      _apiResponse = await joinRoom(_roomKey);

      if (_apiResponse.error != null) {
        // Handle error message
        // print('Error: ${_apiResponse.error}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${_apiResponse.error}'),
          ),
        );
      } else {
        // Handle success data
        // print('Data: ${_apiResponse.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_apiResponse.data}'),
          ),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Join Room')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(32),
            children: [
              TextFormField(
                decoration: kInputDecoration('Room Key'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a room key';
                  }
                  return null;
                },
                onSaved: (value) {
                  _roomKey = value!;
                },
              ),
              ElevatedButton(
                onPressed: _joinRoom,
                child: Text('Join room'),
              ),
            ],
          ),
        ));
  }
}
