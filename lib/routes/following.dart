import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cs310_step2/utils/colors.dart';
import 'package:cs310_step2/utils/styles.dart';
import 'package:cs310_step2/classes/classes.dart';
import 'package:cs310_step2/classes/models.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class Following extends StatefulWidget {

  const Following({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _FollowingState createState() => _FollowingState();
}

class _FollowingState extends State<Following> {

  List<AppUser> users = [
    AppUser(username: 'username #1', mail: '', gsm: '', password: '', postCount: 0, followersCount: 0, followingCount: 0, bio: 'desc #1', isPrivate: true, profilePhoto: ''),
    AppUser(username: 'username #2', mail: '', gsm: '', password: '', postCount: 0, followersCount: 0, followingCount: 0, bio: 'desc #2', isPrivate: true, profilePhoto: ''),
    AppUser(username: 'username #3', mail: '', gsm: '', password: '', postCount: 0, followersCount: 0, followingCount: 0, bio: 'desc #1', isPrivate: true, profilePhoto: ''),
    AppUser(username: 'username #4', mail: '', gsm: '', password: '', postCount: 0, followersCount: 0, followingCount: 0, bio: 'desc #2', isPrivate: true, profilePhoto: ''),
    AppUser(username: 'username #5', mail: '', gsm: '', password: '', postCount: 0, followersCount: 0, followingCount: 0, bio: 'desc #1', isPrivate: true, profilePhoto: ''),
    AppUser(username: 'username #6', mail: '', gsm: '', password: '', postCount: 0, followersCount: 0, followingCount: 0, bio: 'desc #2', isPrivate: true, profilePhoto: ''),
    AppUser(username: 'username #7', mail: '', gsm: '', password: '', postCount: 0, followersCount: 0, followingCount: 0, bio: 'desc #1', isPrivate: true, profilePhoto: ''),
    AppUser(username: 'username #8', mail: '', gsm: '', password: '', postCount: 0, followersCount: 0, followingCount: 0, bio: 'desc #2', isPrivate: true, profilePhoto: ''),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        title: Text(
          'Username #1',
          style: mainTitleTextStyle,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0.0,
      ),
      body: Container(
        color: AppColors.background,
        width: 500,
        height: 1000,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(),
            Text(
              'Following',
              style: bodyLargeTextStyle,
            ),
            Container(
              width: 350,
              height: 450,
              child: ListView(
                padding: EdgeInsets.all(0.0),
                children: users.map(
                        (user) => UsersSection(
                        user: user
                    )
                ).toList(),
              ),
            ),
            SizedBox(),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}