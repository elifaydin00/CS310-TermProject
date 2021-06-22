import 'package:flutter/material.dart';
import 'package:cs310_step2/utils/colors.dart';
import 'package:cs310_step2/utils/styles.dart';
import 'package:cs310_step2/classes/classes.dart';
import 'package:cs310_step2/classes/models.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:cs310_step2/utils/analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class AddPost2 extends StatefulWidget {
  const AddPost2({Key key, this.analytics, this.observer}) : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _AddPost2State createState() => _AddPost2State();
}
class _AddPost2State extends State<AddPost2> {

  String _description;

  User firebaseUser = FirebaseAuth.instance.currentUser;

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future uploadImage(BuildContext context) async {
    //print('1. $_imageFile');
    //print('2. $photofilename');
    firebase_storage.Reference firebaseStorageRef =
    firebase_storage.FirebaseStorage.instance.ref().child('photos').child(photofilename);
    firebase_storage.UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Completed: $value"),
    );
    await addnewpost();
    Navigator.pushNamed(context, '/profile');
  }

  Post usersPosts;

  static Map<String, dynamic> toMap(Post post) => {
    'imageUrl': post.imageUrl,
    'userPhotoUrl': post.userPhotoUrl,
    'imagePath': post.imagePath,
    'description': post.description,
    'likes': post.likes,
    'dislikes': post.dislikes,
    'reports': post.reports,
    'commentUsersID': post.commentUsersID,
    'comments': post.comments,
    'likeUsersID': post.likeUsersID,
    'dislikeUsersID': post.dislikeUsersID,
    'reportUserID': post.reportUsersID,
  };

  String photoUrl2 = '';

  Future<void> addnewpost() async {
    if (_description == null) {
      _description = '';
    }
    usersPosts = Post(imagePath: ('/photos/' + photofilename), description: _description, likes: 0, dislikes: 0, reports: 0);



    firebase_storage.Reference image = firebase_storage.FirebaseStorage.instance.ref().child('/photos/' + photofilename);
    final imageUrl = await image.getDownloadURL();
    String photoUrl1 = imageUrl.toString();

    usersPosts.imageUrl = photoUrl1;
    usersPosts.userPhotoUrl = photoUrl2;
    usersPosts.comments = [];
    usersPosts.commentUsersID = [];
    usersPosts.likeUsersID = [];
    usersPosts.dislikeUsersID = [];
    usersPosts.reportUsersID = [];


    //print('A1: $usersPosts, ${usersPosts.description}, ${usersPosts.likes}, ');
    userCollection.doc(firebaseUser.uid).update({'usersPosts': FieldValue.arrayUnion([toMap(usersPosts)])});
    userCollection.doc(firebaseUser.uid).update({'postCount': (postAmount + 1)});

    //print('A2: $usersPosts');
  }

  //FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;
  String username, profilePhoto;
  int postAmount;
  Map<String, dynamic> elements;
  File _imageFile;
  String photofilename;

  Future<void> loadPhoto() async {
    await userCollection.doc(firebaseUser.uid).get().then(
            (DocumentSnapshot documentSnapshot) {
          setState(() {
            username = documentSnapshot['username'];
            profilePhoto = documentSnapshot['profilePhoto'];
            postAmount = documentSnapshot['postCount'];
          });
        }
    );
    if (profilePhoto != '') {
      firebase_storage.Reference userImage = firebase_storage.FirebaseStorage
          .instance.ref().child(profilePhoto);
      final userImageUrl = await userImage.getDownloadURL();
      setState(() {
        photoUrl2 = userImageUrl.toString();
      });
    } else {
      photoUrl2 = '';
    }
  }


  @override
  void initState() {
    super.initState();
    //enableCrashlytics();
    setCurrentScreen(widget.analytics, widget.observer, 'AddPost2', 'AddPost2State');

    loadPhoto();
  }

  //Post({ this.imageUrl, this.description, this.date, this.locName, this.likes, this.dislikes, this.commentCount });
  @override
  Widget build(BuildContext context) {
    elements = ModalRoute.of(context).settings.arguments;
    _imageFile = elements["image"];
    //print(_imageFile);
    photofilename = elements["filename"];
    //print(photofilename);
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(),
              Text(
                'Add New Post',
                style: mainTitleTextStyle,
              ),
              IconButton(
                onPressed: () {
                  uploadImage(context);
                  //addnewpost();
                  //Navigator.pushNamed(context, '/profile');
                },
                splashRadius: 30,
                icon: Icon(
                    IconData(59087, fontFamily: 'MaterialIcons'), //on clicked wrap the post, add it to list
                    color: AppColors.text
                ),
                iconSize: 45,
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          elevation: 0.0,
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 35),
              Row(
                children: <Widget>[
                  CircleAvatar( //profile picture
                    backgroundImage: NetworkImage(
                      (photoUrl2 == '' ? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png" : photoUrl2),
                    ),
                    backgroundColor: Colors.green,
                    radius: 40,
                  ),
                  //onTap: () {); }, //zoom photo


                  SizedBox(width:12),

                  Expanded(
                    child: TextFormField(
                      style: TextStyle(
                          color: AppColors.text
                      ),
                      decoration: InputDecoration(
                        counterText: ' ',
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF9885B1))),
                        labelText: 'Add description',
                        labelStyle: TextStyle(color: AppColors.text),
                      ),
                      onChanged: (String value) {
                        _description = value;
                      },
                    ),
                  ),

                ],
              ),

              const Divider(
                height: 20,
                thickness: 1,
                indent: 10,
                endIndent: 10,
                color:Colors.orangeAccent,
              ),
              /*
              ElevatedButton(
                onPressed: () { //add location via google maps
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(AppColors.primary),
                  elevation: MaterialStateProperty.all(10),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
                ),
                child: Text(
                  'Add location',
                  style: bodyNormalTextStyle,
                ),
              )
              */
            ],
          ),
        )
    );
  }
}