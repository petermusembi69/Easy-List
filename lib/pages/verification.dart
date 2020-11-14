import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_courses/scoped-models/main.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class Verification extends StatefulWidget {
  String phoneNumber;

  Verification(this.phoneNumber);
  @override
  State<StatefulWidget> createState() {
    return _VerificationState();
  }
}

class _VerificationState extends State<Verification> {
  final verificationKey = GlobalKey<FormState>();
  FirebaseAuth user;
  String verificationCode;
  String smsCode;
  var dime = TimeoutException('resend now', Duration(seconds: 30));

  Future<void> _submit() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verid) {
      this.verificationCode = verid;
    };
    final PhoneCodeSent phoneCodeSent = (String verid, [int forceResendCode]) {
      this.verificationCode = verid;
    };
    final PhoneVerificationCompleted phoneVerificationCompleted = (user) {
      print('success');
    };
    final PhoneVerificationFailed phoneVerificationFailed =
        (AuthException exception) {
      print(exception.message);
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        timeout: const Duration(seconds: 30),
        verificationCompleted: phoneVerificationCompleted,
        verificationFailed: phoneVerificationFailed,
        codeSent: phoneCodeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout);
  }
// africas talking api endpoint
// Sandbox: https://api.sandbox.africastalking.com/version1/messaging

  @override
  Widget build(BuildContext context) {
    var dime2 = dime;
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Verification'),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    height: 150.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/moving1.png'),
                          fit: BoxFit.fitHeight,
                        ),
                        borderRadius: BorderRadius.circular(70)),
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  '''Enter the 4 digt number that
  was sent to ${widget.phoneNumber}''',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    height: 120.0,
                    child: Column(
                      children: <Widget>[
                        Form(
                          key: verificationKey,
                          child: SingleChildScrollView(
                            child: TextFormField(
                              maxLength: 4,
                              onChanged: (String value) {
                                smsCode = value;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        FlatButton(
                            child: Text('Continue'),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              _submit().then((_) {
                                FirebaseAuth.instance
                                    .currentUser()
                                    .then((user) {
                                  if (user != null) {
                                    Navigator.pushReplacementNamed(
                                        context, '/products');
                                  } else {
                                    return;
                                  }
                                });
                              });
                            }),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(blurRadius: 3)],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('${dime2}'),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
