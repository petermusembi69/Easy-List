import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../models/database.dart';
import '../models/profile.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileEditPageState();
  }
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _profileKey = GlobalKey<FormState>();
  final _userName = TextEditingController();
  final _fullNames = TextEditingController();
  final _dateOfbirth = TextEditingController();
  final _phoneNumber = TextEditingController();
  final format = DateFormat("yyyy-MM-dd");

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Profile'),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit),
            ),
          ],
        ),
        body:
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     shape: BoxShape.circle,
            //     // borderRadius: BorderRadius.circular(30),
            //   ),
            //   child: Icon(Icons.add_a_photo),
            //   padding: EdgeInsets.all(15),
            //   height: 150.0,
            //   width: 150,
            // ),

            SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Form(
                  key: _profileKey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // ImageInput(_setImage),
                      Text(
                        'Personal Information',
                        style: TextStyle(color: Colors.orangeAccent),
                      ),
                      username(),
                      fullnames(),
                      dateofbirth(),
                      Text(
                        'Contact Information',
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 16,
                        ),
                      ),
                      phonenumber(),
                      email(model.user.email),
                      Text(
                        'General Information',
                        style: TextStyle(color: Colors.orangeAccent),
                      ),
                      status(model.getTradeMode),
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                        onPressed: () {
                          var useremail = model.user.email;
                          print(useremail);
                          if (!_profileKey.currentState.validate()) {
                            return;
                          }
                          _profileKey.currentState.save();

                          ProfileDatabase().insertUser(
                            Profile(
                                id: null,
                                username: _userName.text,
                                fullname: _fullNames.text,
                                dateofbirth: (_dateOfbirth.text),
                                phonenumber: int.parse(_phoneNumber.text),
                                email: useremail,
                                status: model.getTradeMode),
                          );
                          Navigator.pushReplacementNamed(
                            context,'/'
                          );
                          print(ProfileDatabase().getUserInfo());
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 30.0, right: 30.0),
                          // padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Update Profile',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // FlatButton(
                      //   onPressed: () {
                      //     model.logOut();
                      //   },
                      //   child: Text('Log out'),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget username() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _userName,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: 'Username',
          prefixIcon: Icon(Icons.person),
          fillColor: Colors.white30,
          // border: OutlineInputBorder( borderRadius: BorderRadius.all( ), ),
        ),
        validator: (String value) {
          return value.isEmpty ? 'Username field is empty' : null;
        },
        // onChanged: () => {},
      ),
    );
  }

  Widget fullnames() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _fullNames,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          prefixIcon: Icon(Icons.person_outline),
          labelText: 'Full Names',
          fillColor: Colors.white30,
          // border: OutlineInputBorder( borderRadius: BorderRadius.all( ), ),
        ),
        validator: (String value) {
          return value.isEmpty ? 'Full Name field is empty' : null;
        },
      ),
    );
  }

  Widget dateofbirth() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DateTimeField(
        format: format,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          prefixIcon: Icon(Icons.cake),
          labelText: 'Date of Birth',
          fillColor: Colors.white30,
          // border: OutlineInputBorder( borderRadius: BorderRadius.all( ), ),
        ),
        controller: _dateOfbirth,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
      ),
    );
  }

  Widget phonenumber() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _phoneNumber,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          prefixIcon: Icon(Icons.phone),
          labelText: 'Phone Number',
          hintText: '07*** *** **',
          fillColor: Colors.white30,
          // border: OutlineInputBorder( borderRadius: BorderRadius.all( ), ),
        ),
        validator: (String value) {
          return value.isEmpty || value.length != 10
              ? 'Phone Number is invalid'
              : null;
        },
      ),
    );
  }

  Widget email(userEmail) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        readOnly: true,
        initialValue: userEmail,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          prefixIcon: Icon(Icons.email),
          labelText: 'Email',
          fillColor: Colors.white30,
          // border: OutlineInputBorder( borderRadius: BorderRadius.all( ), ),
        ),
      ),
    );
  }

  Widget status(statusMode) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        readOnly: true,
        initialValue: statusMode,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          prefixIcon: Icon(Icons.store_mall_directory),
          labelText: 'Status,',
          fillColor: Colors.white30,
          // border: OutlineInputBorder( borderRadius: BorderRadius.all( ), ),
        ),
      ),
    );
  }
}
