import 'package:flutter/material.dart';

class Profile {
  final int id;
  final String username;
  final String fullname;
  final String dateofbirth;
  final int phonenumber;
  final String email;
  final String status;

  Profile({
    @required this.id,
    @required this.username,
    @required this.fullname,
    @required this.dateofbirth,
    @required this.phonenumber,
    @required this.email,
    @required this.status,
  });

  toMap() {
    return {
      "id": id,
      "username": username,
      "fullname": fullname,
      "dateofbirth" : dateofbirth,
      "phonenumber": phonenumber,
      "email": email,
      "status": status
    };
  }

}
