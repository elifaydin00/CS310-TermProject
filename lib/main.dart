import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:cs310_step2/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cs310_step2/routes/walkthrough.dart';
import 'package:cs310_step2/routes/welcome.dart';
import 'package:cs310_step2/routes/login.dart';
import 'package:cs310_step2/routes/signup.dart';
import 'package:cs310_step2/routes/feed.dart';
import 'package:cs310_step2/routes/search.dart';
import 'package:cs310_step2/routes/profile.dart';
import 'package:cs310_step2/routes/zoomedphoto.dart';
import 'package:cs310_step2/routes/notifications.dart';
import 'package:cs310_step2/routes/changepassword.dart';
import 'package:cs310_step2/routes/deactivateaccount.dart';
import 'package:cs310_step2/routes/deleteaccount.dart';
import 'package:cs310_step2/routes/settingsall.dart';
import 'package:cs310_step2/routes/profilesettings.dart';
import 'package:cs310_step2/routes/profileothers.dart';
import 'package:cs310_step2/routes/followers.dart';
import 'package:cs310_step2/routes/following.dart';
import 'package:cs310_step2/routes/messagesall.dart';
import 'package:cs310_step2/routes/messagesprivate.dart';
import 'package:cs310_step2/routes/contacts.dart';
import 'package:cs310_step2/routes/addpost.dart';
import 'package:cs310_step2/routes/addpost2.dart';


void main() async { //async because we will wait for FireBase to initiliaze
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
        builder: (context, snapshot) {
          print('Firebase connected');
          return StreamProvider<User>.value( //we will listen to Auth (we return User from FireBase)
            value: Auth().user,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: AppBase(),
            ),
          );
        }
    );
  }
}

class AppBase extends StatelessWidget {
  const AppBase({
    Key key,
  }) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      navigatorObservers: <NavigatorObserver>[observer],
      initialRoute: '/walkthrough',
      routes: {
        '/walkthrough': (context) => Walkthrough(analytics: analytics, observer: observer),
        '/welcome': (context) => Welcome(analytics: analytics, observer: observer),
        '/login': (context) => Login(analytics: analytics, observer: observer),
        '/signup': (context) => SignUp(analytics: analytics, observer: observer),
        '/feed': (context) => Feed(analytics: analytics, observer: observer),
        '/search': (context) => Search(analytics: analytics, observer: observer),
        '/messagesall': (context) => DirectMessagesAll(analytics: analytics, observer: observer),
        '/profile': (context) => Profile(analytics: analytics, observer: observer),
        '/zoomedphoto': (context) => ZoomedPhoto(analytics: analytics, observer: observer),
        '/notifications': (context) => Notifications(analytics: analytics, observer: observer),
        '/changepassword': (context) => ChangePassword(analytics: analytics, observer: observer),
        '/deactivateaccount': (context) => DeactivateAccount(analytics: analytics, observer: observer),
        '/deleteaccount': (context) => DeleteAccount(analytics: analytics, observer: observer),
        '/settingsall': (context) => SettingsAll(analytics: analytics, observer: observer),
        '/profilesettings': (context) => ProfileSettings(analytics: analytics, observer: observer),
        '/profileothers': (context) => ProfileOthers(analytics: analytics, observer: observer),
        '/followers': (context) => Followers(analytics: analytics, observer: observer),
        '/following': (context) => Following(analytics: analytics, observer: observer),
        '/contacts': (context) => Contacts(analytics: analytics, observer: observer),
        '/messagesprivate': (context) => DirectMessagesPrivate(analytics: analytics, observer: observer),
        '/addpost': (context) => AddPost(analytics: analytics, observer: observer),
        '/addpost2': (context) => AddPost2(analytics: analytics, observer: observer),
      },
    );
  }
}