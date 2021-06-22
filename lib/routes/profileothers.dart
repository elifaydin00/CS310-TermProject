import 'package:flutter/material.dart';
import 'package:cs310_step2/utils/colors.dart';
import 'package:cs310_step2/utils/styles.dart';
import 'package:cs310_step2/classes/classes.dart';
import 'package:cs310_step2/classes/models.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs310_step2/utils/analytics.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ProfileOthers extends StatefulWidget {
  const ProfileOthers({Key key, this.analytics, this.observer}) : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _ProfileOthersState createState() => _ProfileOthersState();
}

class _ProfileOthersState extends State<ProfileOthers> {

  User firebaseUser = FirebaseAuth.instance.currentUser;
  final CollectionReference userCollection = FirebaseFirestore.instance
      .collection('users');

  List<dynamic> followersRaw = [];
  List<String> followers = [];

  static Map<String, dynamic> toMap(Notifi notifi) =>
      {
        'userID': notifi.userID,
        'message': notifi.message,
      };

  List<dynamic> currNotifsRaw = [];
  List<String> currNotifs = [];
  bool alreadySentReq;

  Future<void> alreadySent() async {
    await FirebaseFirestore.instance.collection('users')
        .where('username', isEqualTo: user.username)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        followingUsersAccount = doc.id;
      });
    });
    await FirebaseFirestore.instance.collection('users').doc(
        followingUsersAccount).get().then(
            (DocumentSnapshot documentSnapshot) {
          currNotifsRaw = documentSnapshot['userNotifications'];
        }
    );
    for (var i in currNotifsRaw) {
      currNotifs.add(Notifi
          .fromMap(i)
          .userID);
    }
    if (currNotifs.contains(firebaseUser.uid)) {
      alreadySentReq = true;
    } else {
      alreadySentReq = false;
    }
  }

  Future<void> followNewUser() async {
    if (user.isPrivate) {
      //requestSend();
      await FirebaseFirestore.instance.collection('users')
          .where('username', isEqualTo: user.username)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          followingUsersAccount = doc.id;
        });
      });
      Notifi newRequest = Notifi(
          userID: firebaseUser.uid, message: 'wants to follow you.');
      await userCollection.doc(followingUsersAccount).update(
          {'userNotifications': FieldValue.arrayUnion([toMap(newRequest)])});
    } else {
      alreadyFollowing = true;
      await FirebaseFirestore.instance.collection('users')
          .where('username', isEqualTo: user.username)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          followingUsersAccount = doc.id;
        });
      });
      userCollection.doc(firebaseUser.uid).update(
          {'userFollowing': FieldValue.arrayUnion([followingUsersAccount])});
      userCollection.doc(firebaseUser.uid).update(
          {'followingCount': FieldValue.increment(1)});
      userCollection.doc(followingUsersAccount).update(
          {'userFollowers': FieldValue.arrayUnion([firebaseUser.uid])});
      userCollection.doc(followingUsersAccount).update(
          {'followersCount': FieldValue.increment(1)});
    }
    setState(() {});
  }

  String followingUsersAccount;

  Future<void> leaveFollowing() async {
    await FirebaseFirestore.instance.collection('users').where(
        'username', isEqualTo: user.username).get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        followingUsersAccount = doc.id;
      });
    });
    userCollection.doc(firebaseUser.uid).update(
        {'userFollowing': FieldValue.arrayRemove([followingUsersAccount])});
    userCollection.doc(firebaseUser.uid).update(
        {'followingCount': FieldValue.increment(-1)});
    userCollection.doc(followingUsersAccount).update(
        {'userFollowers': FieldValue.arrayRemove([firebaseUser.uid])});
    userCollection.doc(followingUsersAccount).update(
        {'followersCount': FieldValue.increment(-1)});
    alreadyFollowing = false;
    setState(() {});
  }

  bool isHidden = false,
      alreadyFollowing = false;

  List<dynamic> userFollowersRaw = [],
      userFollowingRaw = [];
  List<String> userFollowers = [],
      userFollowing = [];


  void allUpdate() async {
    await loadPosts();
    await updatePage();
  }

  Future<void> loadPosts() async {
    await FirebaseFirestore.instance.collection('users')
        .doc(firebaseUser.uid)
        .get()
        .then(
            (DocumentSnapshot documentSnapshot) {
          authUsername = documentSnapshot['username'];
        }
    );
    await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: user.username)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        posts.clear();
        for (var i in doc["usersPosts"]) {
          posts.add(Post.fromMap(i));
        }
      });
    });
    await FirebaseFirestore.instance.collection('users')
        .doc(firebaseUser.uid)
        .get()
        .then(
            (DocumentSnapshot documentSnapshot) {
          followersRaw = documentSnapshot['userFollowing'];
        }
    );
    followers.clear();
    for (var i in followersRaw) {
      followers.add(i.toString());
    }

    await FirebaseFirestore.instance.collection('users').where(
        'username', isEqualTo: user.username).get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        followingUsersAccount = doc.id;
      });
    });

    if (followers.contains(followingUsersAccount)) {
      alreadyFollowing = true;
    }
  }

  Future<void> updatePage() async {
    userFollowers.clear();
    userFollowing.clear();
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc["username"] == user.username) {
          userFollowersRaw = doc["userFollowers"];
          userFollowingRaw = doc["userFollowing"];
        }
      });
    });

    for (var i in userFollowersRaw) {
      userFollowers.add(i.toString());
    }

    for (var i in userFollowingRaw) {
      userFollowing.add(i.toString());
    }

    followersCount = user.followersCount;
    followingCount = user.followingCount;

    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (userFollowers.contains(doc.id) && doc["isDeactivated"]) {
          userFollowers.remove(doc.id);
          followersCount--;
        }
      });
    });

    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (userFollowing.contains(doc.id) && doc["isDeactivated"]) {
          userFollowing.remove(doc.id);
          followingCount--;
        }
      });
    });


    setState(() {});
  }

  int followersCount = 0,
      followingCount = 0;
  Map<String, dynamic> elements;
  AppUser user;
  List<Post> posts = [];
  String authUsername;
  //FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

  @override
  void initState() {
    super.initState();
    //enableCrashlytics();
    setCurrentScreen(widget.analytics, widget.observer, 'ProfileOthers',
        'ProfileOthersState');
  }

  bool loading = true;

  @override
  void didChangeDependencies() {
    if (loading) {
      elements = ModalRoute
          .of(context)
          .settings
          .arguments;
      user = elements["user"];
      isHidden = user.isPrivate;
      allUpdate();
      loading = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(),
              SizedBox(),
              SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(),
                  ClipOval(
                    child: Material(
                      color: Colors.green,
                      child: InkWell(
                        child: CircleAvatar(
                          backgroundImage: (user.profilePhotoUrl == ''
                              ? NetworkImage(
                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png")
                              : NetworkImage(user.profilePhotoUrl)),
                          backgroundColor: Colors.green,
                          radius: 50,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/zoomedphoto',
                              arguments: {
                                "imageUrl": user.profilePhotoUrl,
                                "username": user.username
                              });
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Center(
                          child: Text(
                            user.username,
                            style: mainTitleTextStyle,
                          ),
                        ),
                        Offstage(
                          offstage: alreadyFollowing,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (isHidden) {
                                await alreadySent();
                                if (alreadySentReq) {
                                  SnackBar sendFriendRequestSnackBar = SnackBar(
                                      content: Text(
                                          "You already sent a follow request!"));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      sendFriendRequestSnackBar);
                                } else {
                                  followNewUser();
                                  SnackBar sendFriendRequestSnackBar = SnackBar(
                                      content: Text(
                                          "You sent a follow request."));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      sendFriendRequestSnackBar);
                                }
                              } else {
                                followNewUser();
                              }
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                  Size(200, 32.5)),
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.primary),
                              elevation: MaterialStateProperty.all(10),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0))),
                            ),
                            child: Text(
                              'Follow',
                              style: bodySmallTextStyle,
                            ),
                          ),
                        ),
                        Offstage(
                          offstage: !alreadyFollowing,
                          child: ElevatedButton(
                            onPressed: () {
                              leaveFollowing();
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                  Size(200, 32.5)),
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.primary),
                              elevation: MaterialStateProperty.all(10),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0))),
                            ),
                            child: Text(
                              'Following',
                              style: bodySmallTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          user.postCount.toString(),
                          style: bodyNormalTextStyle,
                        ),
                        Text(
                          'Posts',
                          style: bodyNormalTextStyle,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/followers', arguments: {
                        "followers": userFollowers,
                        "username": user.username
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            followersCount.toString(),
                            style: bodyNormalTextStyle,
                          ),
                          Text(
                            'Followers',
                            style: bodyNormalTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/following', arguments: {
                        "following": userFollowing,
                        "username": user.username
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            followingCount.toString(),
                            style: bodyNormalTextStyle,
                          ),
                          Text(
                            'Following',
                            style: bodyNormalTextStyle,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Container(
                  width: 350,
                  height: 75,
                  child: Text(
                    'Bio:\n${user.bio}',
                    style: bodyNormalTextStyle,
                  )
              ),
              Container(
                width: 350,
                height: 390,
                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Offstage(
                      offstage: !isHidden || alreadyFollowing,
                      child: Container(
                        width: 350,
                        height: 350,
                        //color: Colors.green,
                        child: Icon(
                          IconData(59459, fontFamily: 'MaterialIcons'),
                          size: 100,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: !(!isHidden || alreadyFollowing),
                      child: Container(
                        width: 350,
                        height: 350,
                        child: ListView(
                          padding: EdgeInsets.all(0.0),
                          children: posts.map(
                                  (post) =>
                                  PostsOthersSection(
                                    post: post,
                                    like: () {},
                                    dislike: () {},
                                    makeComment: () {},
                                    bookmark: () {},
                                  )
                          ).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.primary,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/feed');
              },
              splashRadius: 30,
              icon: Icon(
                  IconData(0xe7ba, fontFamily: 'MaterialIcons'),
                  color: AppColors.text
              ),
              iconSize: 45,
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
              splashRadius: 30,
              icon: Icon(
                  IconData(60966, fontFamily: 'MaterialIcons'),
                  color: AppColors.text
              ),
              iconSize: 45,
            ),
            /*
            IconButton(
              onPressed: () { Navigator.pushNamed(context, '/messagesall'); },
              splashRadius: 30,
              icon: Icon(
                  IconData(61858, fontFamily: 'MaterialIcons'),
                  color: AppColors.text
              ),
              iconSize: 45,
            ),

             */
          ],
        ),
      ),
    );
  }
}