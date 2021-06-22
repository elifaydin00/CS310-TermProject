import 'package:flutter/material.dart';
import 'package:cs310_step2/utils/colors.dart';
import 'package:cs310_step2/utils/styles.dart';
import 'package:cs310_step2/classes/classes.dart';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' show get;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cs310_step2/routes/profile.dart';

class PostsOwnSection extends StatelessWidget {
  final Post post;
  final Function like;
  final Function dislike;
  final Function share;
  final Function makeComment;
  final Function delete;
  PostsOwnSection({ this.post, this.like, this.dislike, this.share, this.makeComment, this.delete });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.background,
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
        width: 325,
        height: 265,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: post.userPhotoUrl == '' ? NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png") : NetworkImage(post.userPhotoUrl),
              backgroundColor: Colors.green,
              radius: 17.5,
            ),
            SizedBox(width: 5),
            Column(
              children: <Widget>[
                Container(
                  //color: Colors.green,
                  width: 275,
                  height: 175,
                  child: Image.network(
                      post.imageUrl,
                      fit:BoxFit.fill
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: like,
                      splashRadius: 10,
                      icon: Icon(
                          IconData(60024, fontFamily: 'MaterialIcons'),
                          color: AppColors.text,
                          size: 15
                      ),
                      //iconSize: 15,
                    ),
                    Container(
                      height: 25,
                      width: 30,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            post.likes.toString(),
                            style: bodyVerySmallTextStyle
                        ),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: dislike,
                      splashRadius: 10,
                      icon: Icon(
                          IconData(60021, fontFamily: 'MaterialIcons'),
                          color: AppColors.text,
                          size: 15
                      ),
                      //iconSize: 15,
                    ),
                    Container(
                      height: 25,
                      width: 30,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            post.dislikes.toString(),
                            style: bodyVerySmallTextStyle
                        ),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: share,
                      splashRadius: 10,
                      icon: Icon(
                          IconData(59864, fontFamily: 'MaterialIcons'),
                          color: AppColors.text,
                          size: 15
                      ),
                      //iconSize: 15,
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: makeComment,
                      splashRadius: 10,
                      icon: Icon(
                          IconData(59514, fontFamily: 'MaterialIcons'),
                          color: AppColors.text,
                          size: 15
                      ),
                      //iconSize: 15,
                    ),
                    SizedBox(width: 90),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: delete,
                      splashRadius: 10,
                      icon: Icon(
                          IconData(59041, fontFamily: 'MaterialIcons'),
                          color: AppColors.text,
                          size: 15
                      ),
                      //iconSize: 15,
                    ),
                  ],
                ),
                Container(
                  child: Text(
                    post.description,
                    style: bodySmallTextStyle,
                  ),
                  //color: Colors.green,
                  width: 275,
                  height: 45,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PostsOthersSection extends StatelessWidget {
  final Post post;
  final Function like;
  final Function dislike;
  final Function share;
  final Function makeComment;
  final Function bookmark;
  PostsOthersSection({ this.post, this.like, this.dislike, this.share, this.makeComment, this.bookmark });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.background,
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
        width: 325,
        height: 265,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipOval(
              child: Material(
                color: Colors.green,
                child: InkWell(
                  child: CircleAvatar(
                    backgroundImage: post.userPhotoUrl == '' ? NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png") : NetworkImage(post.userPhotoUrl),
                    backgroundColor: Colors.green,
                    radius: 17.5,
                  ),
                  onTap: () { Navigator.pushNamed(context, '/profileothers'); },
                ),
              ),
            ),
            SizedBox(width: 5),
            Column(
              children: <Widget>[
                Container(
                  //color: Colors.green,
                  width: 275,
                  height: 175,
                  child: Image.network(
                      post.imageUrl == '' ? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png" : post.imageUrl,
                      fit:BoxFit.fill
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: like,
                      splashRadius: 10,
                      icon: Icon(
                          IconData(60024, fontFamily: 'MaterialIcons'),
                          color: AppColors.text,
                          size: 15
                      ),
                      //iconSize: 15,
                    ),
                    Container(
                      height: 25,
                      width: 30,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            post.likes.toString(),
                            style: bodyVerySmallTextStyle
                        ),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: dislike,
                      splashRadius: 10,
                      icon: Icon(
                          IconData(60021, fontFamily: 'MaterialIcons'),
                          color: AppColors.text,
                          size: 15
                      ),
                      //iconSize: 15,
                    ),
                    Container(
                      height: 25,
                      width: 30,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            post.dislikes.toString(),
                            style: bodyVerySmallTextStyle
                        ),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: share,
                      splashRadius: 10,
                      icon: Icon(
                          IconData(59864, fontFamily: 'MaterialIcons'),
                          color: AppColors.text,
                          size: 15
                      ),
                      //iconSize: 15,
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: makeComment,
                      splashRadius: 10,
                      icon: Icon(
                          IconData(59514, fontFamily: 'MaterialIcons'),
                          color: AppColors.text,
                          size: 15
                      ),
                      //iconSize: 15,
                    ),
                    SizedBox(width: 90),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: bookmark,
                      splashRadius: 10,
                      icon: Icon(
                          IconData(0xe5f8, fontFamily: 'MaterialIcons'),
                          color: AppColors.text,
                          size: 15
                      ),
                      //iconSize: 15,
                    ),
                  ],
                ),
                Container(
                  child: Text(
                    post.description,
                    style: bodySmallTextStyle,
                  ),
                  //color: Colors.green,
                  width: 275,
                  height: 45,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationSection extends StatefulWidget {

  static Map<String, dynamic> toMap(Notifi notifi) => {
    'userID': notifi.userID,
    'message': notifi.message,
  };

  final Notifi currNotification;
  NotificationSection({ this.currNotification });

  @override
  _NotificationSectionState createState() => _NotificationSectionState();
}

class _NotificationSectionState extends State<NotificationSection> {
  User firebaseUser = FirebaseAuth.instance.currentUser;

  Future<void> updatePage() async {
    await FirebaseFirestore.instance.collection('users')
        .doc(widget.currNotification.userID)
        .get()
        .then(
            (DocumentSnapshot documentSnapshot) {
          username = documentSnapshot['username'];
          photo = documentSnapshot['profilePhotoUrl'];
        }
    );
    setState(() {

    });
  }

  String username = '', photo = '';
  String thatUsername;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  String followingUsersAccount;

  Future<void> approve() async {
    followingUsersAccount = widget.currNotification.userID;
    userCollection.doc(firebaseUser.uid).update({'userFollowers': FieldValue.arrayUnion([followingUsersAccount])});
    userCollection.doc(firebaseUser.uid).update({'followersCount': FieldValue.increment(1)});
    userCollection.doc(followingUsersAccount).update({'userFollowing': FieldValue.arrayUnion([firebaseUser.uid])});
    userCollection.doc(followingUsersAccount).update({'followingCount': FieldValue.increment(1)});
    await userCollection.doc(firebaseUser.uid).update({'userNotifications': FieldValue.arrayRemove([NotificationSection.toMap(widget.currNotification)])});
    setState(() {});
  }

  Future<void> decline() async {
    await userCollection.doc(firebaseUser.uid).update({'userNotifications': FieldValue.arrayRemove([NotificationSection.toMap(widget.currNotification)])});
    setState(() {});
  }


  @override
  void initState() {
    updatePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipOval(
        child: Material(
          child: CircleAvatar(
            backgroundImage: (photo == '' ? NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png") : NetworkImage(photo)),
            backgroundColor: Colors.green,
            radius: 30,
          ),
        ),
      ),
      title: Text(
          username,
          style: verySmallFancyTextStyle
      ),
      subtitle: Text(
        '${widget.currNotification.message}',
        style: bodySmallTextStyle,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: (() async { await approve(); Navigator.pushNamed(context, '/notifications'); }),
            icon: Icon(
              Icons.check,
              color: Colors.green,
              size: 45,
            ),
          ),
          IconButton(
            onPressed: (() async { await decline(); Navigator.pushNamed(context, '/notifications'); }),
            icon: Icon(
              Icons.close,
              color: Colors.red,
              size: 45,
            ),
          ),
        ],
      ),
    );
  }
}

class UsersSection extends StatelessWidget {
  final AppUser user;
  UsersSection({ this.user });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.background,
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
        width: 325,
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: CircleAvatar(
                backgroundImage: (user.profilePhotoUrl == '' ? NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png") : NetworkImage(user.profilePhotoUrl)),
                backgroundColor: Colors.green,
              ),
              width: 65,
              height: 65,
            ),
            SizedBox(width: 5),
            InkWell(
              onTap: () { Navigator.pushNamed(context, '/profileothers', arguments: {'user': user}); },
              splashColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                //color: Colors.green,
                width: 245,
                height: 65,
                child: Text(
                  user.username,
                  style: bodySmallTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UsersMessagesSection extends StatelessWidget {
  final AppUser user;
  UsersMessagesSection({ this.user });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.background,
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
        width: 325,
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.green,
              width: 65,
              height: 65,
            ),
            SizedBox(width: 5),
            InkWell(
              onTap: () { Navigator.pushNamed(context, '/messagesprivate'); },
              splashColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                //color: Colors.green,
                width: 245,
                height: 65,
                child: Text(
                  '${user.username}',
                  style: bodySmallTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyMessages extends StatelessWidget {
  final AppUser user;
  final String msg;
  MyMessages({ this.user, this.msg });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.background,
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
        width: 325,
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.green,
              width: 65,
              height: 65,
            ),
            SizedBox(width: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              //color: Colors.green,
              width: 245,
              height: 65,
              child: Text(
                '$msg',
                style: bodySmallTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class YourMessages extends StatelessWidget {
  final String msg;
  YourMessages({ this.msg });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.background,
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
        width: 325,
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              //color: Colors.green,
              width: 245,
              height: 65,
              child: Text(
                '$msg',
                style: bodySmallTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Messages extends StatelessWidget {
  final String msg;
  final String type;

  Messages({ this.msg, this.type });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.background,
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
        width: 325,
        height: 75,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          //color: Colors.green,
          width: 245,
          height: 65,
          child: Align(
            alignment: (type == "receiver" ? Alignment.topLeft : Alignment
                .topRight),
            child: Container(
              child: Text(
                '$msg',
                style: bodySmallTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}