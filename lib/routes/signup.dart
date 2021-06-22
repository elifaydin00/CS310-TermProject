import 'package:flutter/material.dart';
import 'package:cs310_step2/utils/colors.dart';
import 'package:cs310_step2/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:cs310_step2/utils/analytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310_step2/services/auth.dart';
import 'package:cs310_step2/services/database.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final Auth _auth = Auth();
  String _message = '';


  void setmessage(String msg) {
    setState(() {
      _message = msg;
    });
  }

  bool exist;

  Future<void> _createUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc["username"] == username) {
          exist = true;
        }
      });
    });
    if (exist) {
      setmessage('User registration failed.');
      exist = false;
    } else {
      dynamic result = await _auth.registerWithEmailAndPassword(username, mail, telephoneNumber, password);

      if (result != null) { //succesfully registered and returned user
        setEnteredAppStatus();
        Navigator.pushNamed(context, '/feed');
      } else {
        setmessage('User registration failed.');
      }
    }
  }

  bool isEnteredApp = false;
  String username;
  String mail;
  String telephoneNumber;
  String password;
  final _formKey = GlobalKey<FormState>();

  setEnteredAppStatus() async { //set preferences enterApp as true
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('enteredApp', true);
  }

  loadEnteredAppStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() { //set state of the variable isEnteredApp true by gettings it from prefs
      isEnteredApp = prefs.getBool('enteredApp'); }
    );
  }

  @override
  void initState() {
    super.initState();

    setCurrentScreen(widget.analytics, widget.observer, 'SignUp', 'SignUpState'); //we will see screen names in each page
    loadEnteredAppStatus();
    exist = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
            'FooBar App',
            style: mainTitleTextStyle
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
            children: <Widget>[
              SizedBox(height: 50),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Sign Up',
                    style: fancyTextStyle,
                  )
              ),
              SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 00),
                      child: TextFormField(
                        style: TextStyle(
                            color: AppColors.text
                        ),
                        decoration: InputDecoration(
                          counterText: ' ',
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF9885B1))),
                          labelText: 'Username',
                          labelStyle: TextStyle(color: AppColors.text),
                        ),
                        validator: (value) {
                          if(value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                        onChanged: (String value) {
                          username = value;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        style: TextStyle(
                            color: AppColors.text
                        ),
                        decoration: InputDecoration(
                          counterText: ' ',
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF9885B1))),
                          labelText: 'E-mail',
                          labelStyle: TextStyle(color: AppColors.text),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if(value.isEmpty) {
                            return 'Please enter your e-mail';
                          }
                          if(!EmailValidator.validate(value)) {
                            return 'The e-mail address is not valid';
                          }
                          return null;
                        },
                        onChanged: (String value) {
                          mail = value;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        style: TextStyle(
                            color: AppColors.text
                        ),
                        decoration: InputDecoration(
                          counterText: ' ',
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF9885B1))),
                          labelText: 'GSM',
                          labelStyle: TextStyle(color: AppColors.text),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if(value.isEmpty) {
                            return 'Please enter your telephone number';
                          }
                          return null;
                        },
                        onChanged: (String value) {
                          telephoneNumber = value;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        obscureText: true,
                        style: TextStyle(
                            color: AppColors.text
                        ),
                        decoration: InputDecoration(
                          counterText: ' ',
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF9885B1))),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: AppColors.text),
                        ),
                        keyboardType: TextInputType.text,
                        enableSuggestions: false,
                        autocorrect: false,
                        validator: (value) {
                          if(value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if(value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                        onChanged: (String value) {
                          password = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                  padding: EdgeInsets.fromLTRB(100, 10, 100, 0),
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _createUser();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(AppColors.primary),
                      elevation: MaterialStateProperty.all(10),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
                    ),
                    child: Text(
                      'Sign Up',
                      style: bodyNormalTextStyle,
                    ),
                  )
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                    '$_message',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.red[900],
                    )
                ),
              ),
            ]
        ),
      ),
    );
  }
}