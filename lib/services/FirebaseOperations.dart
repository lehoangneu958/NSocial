import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nsocial/screens/landingPage/landingUtils.dart';
import 'package:nsocial/services/Authentication.dart';
import 'package:provider/provider.dart';

class FirebaseOperations with ChangeNotifier {
  late UploadTask imageUploadTask;
  late String initUserEmail, initUserName, initUserImage;
  String get getInitUserEmail => initUserEmail;
  String get getInitUserName => initUserName;
  String get getInitUserImage => initUserImage;
  Future uploadUserAvatar(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userProfileAvatar/${Provider.of<LandingUtils>(context, listen: false).getUserAvatar.path}/${TimeOfDay.now()}');

    imageUploadTask = imageReference.putFile(
        Provider.of<LandingUtils>(context, listen: false).getUserAvatar);
    await imageUploadTask.whenComplete(() => {print('Image uploaded!')});
    imageReference.getDownloadURL().then((url) {
      Provider.of<LandingUtils>(context, listen: false).userAvatarUrl =
          url.toString();
      print(
          'The user profile avatar url => ${Provider.of<LandingUtils>(context, listen: false).userAvatarUrl}');
      notifyListeners();
    });
  }

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set(data);
  }

  Future initUserData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((doc) {
      print('Fetching user data');
      initUserName = doc['username'];
      initUserEmail = doc['useremail'];
      initUserImage = doc['userimage'];
      print(initUserName);
      print(initUserEmail);
      print(initUserImage);
      notifyListeners();
    });
  }

  Future uploadPostData(String postId, dynamic data) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  Future deleteUserData(String userUid, dynamic collection) async {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(userUid)
        .delete();
  }

  Future deleteUserPost(String userUid, dynamic collection) async {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(userUid)
        .delete();
  }

  Future updateCation(String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(data);
  }

  Future followUser(
      String followingUid,
      String followingDocId,
      dynamic followingData,
      String followerUid,
      String followerDocId,
      dynamic followerData) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followingUid)
        .collection('followers')
        .doc(followingDocId)
        .set(followingData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(followerUid)
          .collection('following')
          .doc(followerDocId)
          .set(followerData);
    });
  }

  Future submitChatroomData(String chatroomName, dynamic data) async{
    return FirebaseFirestore.instance.collection('chatrooms').doc(chatroomName).set(data);

  }

  Future submitUserChatRoom(String chatroomName, dynamic data, String useruid) async{
    return FirebaseFirestore.instance.collection('users').doc(useruid).collection('chatrooms')
    .doc(chatroomName).set(data);

  }

}
