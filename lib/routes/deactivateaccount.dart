import 'package:flutter/material.dart';
import 'package:cs310_step2/utils/colors.dart';
import 'package:cs310_step2/utils/styles.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:cs310_step2/utils/analytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310_step2/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeactivateAccount extends StatefulWidget {
  const DeactivateAccount({Key key, this.analytics, this.observer}) : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _DeactivateAccountState createState() => _DeactivateAccountState();
}

class _DeactivateAccountState extends State<DeactivateAccount> {

  //FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

  final Auth _auth = Auth();

  User firebaseUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> signOut() async {
    users.doc(firebaseUser.uid).update({'isDeactivated': true});
    await _auth.signOut();
    Navigator.popUntil(context, ModalRoute.withName('/welcome'));
  }

  @override
  void initState() {
    super.initState();
    //enableCrashlytics();
    setCurrentScreen(widget.analytics, widget.observer, 'DeactivateAccount', 'DeactivateAccountState');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Deactivate Account',
          style: mainTitleTextStyle,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Reminder',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Color(0xFF280505),
                  fontWeight: FontWeight.bold,
                  fontSize: 40,

                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'After the deactivaton process you can',
                  style: bodySmallTextStyle
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'activate your account whenever you want.',
                  style: bodySmallTextStyle
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: ElevatedButton(
                  onPressed: () {showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Text("Deactivate account"),
                          content: Text("Are you sure to deactivate your account?"),
                          actions: [
                            FlatButton(onPressed: (){ Navigator.of(context).pop(); }, child: Text('No')),
                            FlatButton(onPressed: (){ Navigator.of(context).pop(); signOut(); }, child: Text('Yes')), //go to welcome page
                          ],
                        );
                      }
                  );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(AppColors.primary),
                    elevation: MaterialStateProperty.all(10),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
                  ),
                  child: Text(
                    'Deactivate',
                    style: bodyNormalTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
