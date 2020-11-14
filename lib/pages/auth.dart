import 'package:flutter/material.dart';
import 'package:flutter_courses/widgets/ui_elements/indicator.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';
import '../models/auth.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  bool visible = false;
  bool visible2 = false;

  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _slideAnimation =
        Tween<Offset>(begin: Offset(0.0, -1.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );
    super.initState();
  }

  Widget _emailField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'E-mail',
        filled: true,
        prefixIcon: Icon(
          Icons.email,
        ),
        fillColor: Colors.white,
      ),
      validator: (String value) {
        return value.isEmpty ||
                !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                    .hasMatch(value)
            ? 'Email is invalid'
            : null;
      },
      keyboardType: TextInputType.emailAddress,
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      obscureText: visible,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock,
        ),
        suffix: GestureDetector(
          onTap: () {
            setState(() {
              if (visible == false) {
                visible = true;
              } else if (visible == true) {
                visible = false;
              }
            });
          },
          child: visible ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
        ),
        labelText: 'Password',
        filled: true,
        fillColor: Colors.white,
      ),
      controller: _passwordTextController,
      // obscureText: true,
      validator: (String value) {
        return value.length < 6 || value.isEmpty ? 'Password is invalid' : null;
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _confirmPasswordField() {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeIn),
      child: SlideTransition(
        position: _slideAnimation,
        child: TextFormField(
          obscureText: visible2,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
            ),
            suffix: GestureDetector(
              onTap: () {
                setState(() {
                  if (visible2 == false) {
                    visible2 = true;
                  } else if (visible2 == true) {
                    visible2 = false;
                  }
                });
              },
              child: visible2
                  ? Icon(Icons.visibility_off)
                  : Icon(Icons.visibility),
            ),
            labelText: 'Confirm Password',
            filled: true,
            fillColor: Colors.white,
          ),
          // obscureText: true,
          validator: (String value) {
            return _passwordTextController.text != value &&
                    _authMode == AuthMode.Signup
                ? 'Password is does not match'
                : null;
          },
        ),
      ),
    );
  }

  Widget _termsField() {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text('Accept terms'),
    );
  }

  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate() ||
        _formData['acceptTerms'] == false) {
      return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> successInformation;
    successInformation = await authenticate(
        _formData['email'], _formData['password'], _authMode);
    if (successInformation['success']) {
      if (_authMode == AuthMode.Login) {
        Navigator.pushReplacementNamed(context, '/');
      } else if (_authMode == AuthMode.Signup) {
        Navigator.pushReplacementNamed(context, '/selectmode');
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('An Error Ocurred!'),
              content: Text(successInformation['message']),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500 : deviceWidth * 0.95;
    return Scaffold(
      appBar: AppBar(title: Text('LOGIN')),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.dstATop),
            image: AssetImage('assets/orange.png'),
          ),
        ),
        padding: EdgeInsets.all(15.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _emailField(),
                    SizedBox(height: 5.0),
                    _passwordField(),
                    SizedBox(height: 5.0),
                    _confirmPasswordField(),
                    SizedBox(height: 5.0),
                    _termsField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    FlatButton(
                      child: Text(
                          'Switch to ${_authMode == AuthMode.Login ? 'SignUp' : 'Login'}'),
                      onPressed: () {
                        setState(() {
                          if (_authMode == AuthMode.Login) {
                            setState(() {
                              _authMode = AuthMode.Signup;
                            });
                            _controller.forward();
                          } else {
                            setState(() {
                              _authMode = AuthMode.Login;
                            });
                            _controller.reverse();
                          }
                        });
                      },
                    ),
                    SizedBox(height: 10.0),
                    ScopedModelDescendant<MainModel>(builder:
                        (BuildContext context, Widget child, MainModel model) {
                      return RaisedButton(
                        child: model.isLoading
                            ? Indicator()
                            : Text(_authMode == AuthMode.Login
                                ? 'LOGIN'
                                : 'SIGN UP'),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () => _submitForm(model.authenticate),
                      );
                    })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
