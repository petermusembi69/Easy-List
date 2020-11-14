import 'package:flutter/material.dart';

final _android = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.orange,
  accentColor: Colors.deepPurpleAccent,
  primaryColor: Colors.deepOrangeAccent[400],
  buttonColor: Colors.deepPurple,
);

final _iOS = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.grey,
  accentColor: Colors.deepPurpleAccent,
  primaryColor: Colors.deepOrangeAccent[400],
  buttonColor: Colors.deepPurple,
);

ThemeData getAdaptiveThemeData(context) {
  return Theme.of(context).platform == TargetPlatform.iOS ? _iOS : _android;
}
