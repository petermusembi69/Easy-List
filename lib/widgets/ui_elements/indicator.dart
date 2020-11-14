import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Indicator extends StatelessWidget {
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CircularProgressIndicator()
        : CupertinoActivityIndicator();
  }
}
