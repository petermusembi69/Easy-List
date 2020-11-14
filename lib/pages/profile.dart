import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  final _profileKey2 = GlobalKey<FormState>();
  final format = DateFormat("yyyy-MM-dd");

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        // backgroundColor: Colors.blue,
        appBar: AppBar(
          elevation: 0,
          title: Text('Profile'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Form(
                key: _profileKey2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 650,
                      width: 400,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/download.jpg')),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
