import 'package:flutter/material.dart';
import 'package:cs310_step2/utils/colors.dart';
import 'package:cs310_step2/utils/styles.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:cs310_step2/utils/analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcome extends StatefulWidget {

  const Welcome({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  bool isPassed = false;

  loadPassWalkthroughStatus() async { //so that we wont get back to walkthrough page
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isPassed = prefs.getBool('status'); }
    );
  } 

  @override
  void initState() {
    super.initState();

    setCurrentScreen(widget.analytics, widget.observer, 'Welcome', 'WelcomeState');
    loadPassWalkthroughStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.background,
        width: 500,
        padding: EdgeInsets.fromLTRB(0, 75, 0, 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'FooBar\n   Application',
              style: fancyTextStyle,
            ),
            Image(
                height: 250,
                image: NetworkImage(
                    'https://www.sharesoft.in/wp-content/uploads/2018/02/Blog3.png'
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 175,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () { Navigator.pushNamed(context, '/login'); },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(AppColors.primary),
                      elevation: MaterialStateProperty.all(10),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
                    ),
                    child: Text(
                      'Login',
                      style: bodyNormalTextStyle,
                    ),
                  ),
                ),
                SizedBox(width: 25),
                Container(
                  width: 175,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () { Navigator.pushNamed(context, '/signup'); },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(AppColors.primary),
                      elevation: MaterialStateProperty.all(10),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
                    ),
                    child: Text(
                      'Sign Up',
                      style: bodyNormalTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}