import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nsocial/services/Authentication.dart';
import 'package:nsocial/services/FirebaseOperations.dart';
import 'package:provider/provider.dart';

class GroupMessageHelper with ChangeNotifier{

  sendMessage(BuildContext context, DocumentSnapshot documentSnapshot, TextEditingController messageController){
    return FirebaseFirestore.instance.collection('chatrooms').doc(
      documentSnapshot.id
    ).collection('messages')
    .add({

      'message': messageController.text,
      'time': Timestamp.now(),
      'userimage': Provider.of<FirebaseOperations>(context, listen: false).getInitUserImage,
      'username': Provider.of<FirebaseOperations>(context, listen: false).getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid
    });
  }

}