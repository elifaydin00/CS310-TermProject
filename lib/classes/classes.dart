import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String username;
  String mail;
  String gsm;
  String password;
  int postCount;
  int followersCount;
  int followingCount;
  String bio;
  List<Post> usersPosts;
  List<String> userFollowers;
  List<String> userFollowing;
  List<Chat> usersChats;
  bool isPrivate;
  bool isDeactivated;
  String profilePhoto;
  String profilePhotoUrl;
  AppUser({ this.username, this.mail, this.gsm, this.password, this.postCount, this.followersCount, this.followingCount, this.bio, this.isPrivate, this.isDeactivated, this.profilePhoto, this.profilePhotoUrl });
  AppUser.fromMap(Map map){
    username = map['username'];
    mail = map['mail'];
    gsm = map['gsm'];
    password = map['password'];
    postCount = map['postCount'];
    followersCount = map['followersCount'];
    followingCount = map['followingCount'];
    bio = map['bio'];
    usersPosts = [];
    userFollowers = [];
    userFollowing = [];
    usersChats = [];
    isPrivate = map['isPrivate'];
    isDeactivated = map['isDeactivated'];
    profilePhoto = map['profilePhoto'];
    profilePhotoUrl = map['profilePhotoUrl'];
  }
}

class Post {
  String imagePath;
  String imageUrl;
  String userPhotoUrl;
  String description;
  int likes;
  int dislikes;
  int reports;
  List<String> comments;
  List<String> likeUsersID;
  List<String> dislikeUsersID;
  List<String> reportUsersID;
  List<String> commentUsersID;
  Post({ this.imagePath, this.description, this.likes, this.dislikes, this.reports, this.userPhotoUrl, this.imageUrl});
  static Map<String, dynamic> toMap(Post post) => {
    'imageUrl': post.imageUrl,
    'userPhotoUrl': post.userPhotoUrl,
    'imagePath': post.imagePath,
    'description': post.description,
    'likes': post.likes,
    'dislikes': post.dislikes,
    'reportCount': post.reports,
    'commentedUsers': post.commentUsersID,
    'comments': post.comments,
    'likeUsersID': post.likeUsersID,
    'dislikeUsersID': post.dislikeUsersID,
    'reportUserID': post.reportUsersID,
  };
  Post.fromMap(Map map){
    imageUrl = map['imageUrl'];
    userPhotoUrl = map['userPhotoUrl'];
    imagePath = map['imagePath'];
    description = map['description'];
    likes = map['likes'];
    dislikes = map['dislikes'];
    reports = map['reports'];
    commentUsersID = [];
    comments = [];
    likeUsersID = [];
    dislikeUsersID = [];
    reportUsersID = [];
  }
}

class Notifi {
  String userID;
  String message;
  Notifi({ this.userID, this.message });
  Notifi.fromMap(Map map){
    userID = map['userID'];
    message = map['message'];
  }
}

class ChatType {
  String msg;
  String type;
  ChatType({ this.msg, this.type });
}

class Chat {
  AppUser user;
  List<ChatType> chatbox;
  Chat({ this.user, this.chatbox });
}

//
class MessagesModel {
  String receiverId;
  String senderId;
  String senderName;
  String receiverName;
  String messageBody;
  int createdAt;

  MessagesModel({
    this.receiverId,
    this.senderId,
    this.messageBody,
    this.createdAt,
    this.senderName,
    this.receiverName,
  });

  MessagesModel.fromData(Map<String, dynamic> data)
      : receiverId = data['receiverId'],
        senderId = data['senderId'],
        senderName = data['senderName'],
        receiverName = data['receiverName'],
        messageBody = data['messageBody'],
        createdAt = data['createdAt'];

  static MessagesModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MessagesModel(
      receiverId: map['receiverId'],
      senderId: map['senderId'],
      senderName: map['senderName'],
      receiverName: map['receiverName'],
      messageBody: map['messageBody'],
      createdAt: map['createdAt'],
    );
  }
}

