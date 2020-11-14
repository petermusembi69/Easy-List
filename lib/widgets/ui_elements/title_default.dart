import 'package:flutter/material.dart';

class TitleDefault extends StatelessWidget {
  final String title;

  TitleDefault(this.title);

  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 26.0, fontWeight: FontWeight.bold, fontFamily: 'Oswald'),
    );
  }
}
