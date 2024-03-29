import 'package:flutter/material.dart';

class CustomizedTextStyle {
  static TextStyle welcome = const TextStyle(
    fontFamily: 'Roboto-Black',
    fontWeight: FontWeight.w700,
    fontSize: 10,
    color: Colors.white,
    fontStyle: FontStyle.normal,
  );

  static TextStyle regular = const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 28,
    color: Colors.white,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle bold = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      color: Colors.black,
      backgroundColor: Colors.white60);

  static TextStyle medium = TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 20,
      fontStyle: FontStyle.normal,
      color: Colors.teal.shade900);
}
