import 'package:flutter/material.dart';

// ------ API URLs ------
const baseURL = 'http://143.198.213.49/api';
const loginURL = baseURL + '/login';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/user';
const roomURL = baseURL + '/rooms';
const joinRoomURL = baseURL + '/join';

// ----- Error Messages -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';

// ----- Input Decoration -----

/// Returns an input decoration with a label and a border.
InputDecoration kInputDecoration(String label) {
  return InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.all(10),
      border: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black)));
}

// ----- Button Widget -----

/// Returns a text button with a label and an onPressed function.
TextButton kTextButton(String label, Function onPressed) {
  return TextButton(
    child: Text(
      label,
      style: TextStyle(color: Colors.white),
    ),
    style: ButtonStyle(
        backgroundColor:
            MaterialStateColor.resolveWith((states) => Colors.blue),
        padding: MaterialStateProperty.resolveWith(
            (states) => EdgeInsets.symmetric(vertical: 10))),
    onPressed: () => onPressed(),
  );
}
