import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/screens/AltProfile/alt_profile.dart';
import 'package:nsocial/screens/Messaging/GroupMessage.dart';
import 'package:nsocial/services/Authentication.dart';
import 'package:nsocial/services/FirebaseOperations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatroomHelper with ChangeNotifier {
  late String latestMessageTime;
  String get getLastestMessageTime => latestMessageTime;
  late String chatroomAvatarUrl, chatroomID;
  String get getChatroomID => chatroomID;
  final TextEditingController chatroomNameController = TextEditingController();

  showChatroomDetails(BuildContext context, DocumentSnapshot documentSnapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.27,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: ConstantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: ConstantColors.whiteColor,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: ConstantColors.blueColor),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Members',
                      style: TextStyle(
                          color: ConstantColors.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(documentSnapshot.id)
                        .collection('members')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return new ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return GestureDetector(
                                onTap: () {
                                  if (Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid !=
                                      documentSnapshot.id) {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: AltProfile(
                                                userUid: documentSnapshot.id),
                                            type: PageTransitionType
                                                .bottomToTop));
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: ConstantColors.darkColor,
                                    backgroundImage: NetworkImage(
                                        documentSnapshot['userimage']),
                                  ),
                                ),
                              );
                            }).toList());
                      }
                    },
                  ),
                  color: ConstantColors.transperant,
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: ConstantColors.yellowColor),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Admin',
                      style: TextStyle(
                          color: ConstantColors.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: ConstantColors.transperant,
                        backgroundImage:
                            NetworkImage(documentSnapshot['userimage']),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(documentSnapshot['username'],
                            style: TextStyle(
                                color: ConstantColors.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  showCreateChatroomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: ConstantColors.darkColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4,
                      color: ConstantColors.whiteColor,
                    ),
                  ),
                  Text(
                    'Select Chatroom Avatar',
                    style: TextStyle(
                        color: ConstantColors.greenColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatroomicons')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return new ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return GestureDetector(
                                onTap: () {
                                  print(documentSnapshot['image']);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Container(
                                    height: 10,
                                    width: 40,
                                    child: Image.network(
                                        documentSnapshot['image']),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
                          textCapitalization: TextCapitalization.words,
                          controller: chatroomNameController,
                          style: TextStyle(
                              color: ConstantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'Enter Chatroom ID',
                            hintStyle: TextStyle(
                                color: ConstantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .submitChatroomData(chatroomNameController.text, {
                            'roomavatar': '',
                            'time': Timestamp.now(),
                            'roomname': chatroomNameController.text,
                            'username': Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .getInitUserName,
                            'useremail': Provider.of<FirebaseOperations>(
                                    context,
                                    listen: false)
                                .getInitUserEmail,
                            'userimage': Provider.of<FirebaseOperations>(
                                    context,
                                    listen: false)
                                .getInitUserImage,
                            'useruid': Provider.of<Authentication>(context,
                                    listen: false)
                                .getUserUid,
                          }).whenComplete(() {
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .submitUserChatRoom(
                                    chatroomNameController.text,
                                    {
                                      'roomavatar': '',
                                      'time': Timestamp.now(),
                                      'roomname': chatroomNameController.text,
                                      'username':
                                          Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false)
                                              .getInitUserName,
                                      'useremail':
                                          Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false)
                                              .getInitUserEmail,
                                      'userimage':
                                          Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false)
                                              .getInitUserImage,
                                      'useruid': Provider.of<Authentication>(
                                              context,
                                              listen: false)
                                          .getUserUid,
                                    },
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid);
                          }).whenComplete(() {
                            FirebaseFirestore.instance
                                .collection('chatrooms')
                                .doc(chatroomNameController.text)
                                .collection('members')
                                .doc(Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid)
                                .set({
                              'joined': true,
                              'username': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getInitUserName,
                              'useremail': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getInitUserEmail,
                              'userimage': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getInitUserImage,
                              'time': Timestamp.now()
                            });
                          }).whenComplete(() {
                            Navigator.pop(context);
                          });
                        },
                        backgroundColor: ConstantColors.blueGreyColor,
                        child: Icon(
                          FontAwesomeIcons.plus,
                          color: ConstantColors.yellowColor,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  showChatrooms(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
          .collection('chatrooms')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return new ListView(
            
            children:
                snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                  showLastMessageTime(documentSnapshot['time']);
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child:
                              GroupMessage(documentSnapshot: documentSnapshot),
                          type: PageTransitionType.leftToRight));
                },
                onLongPress: () {
                  showChatroomDetails(context, documentSnapshot);
                },
                title: Text(
                  documentSnapshot['roomname'],
                  style: TextStyle(
                      color: ConstantColors.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: 
                
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chatrooms')
                      .doc(documentSnapshot.id)
                      .collection('messages')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData){
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.data!.docs.first['username'] != null &&
                          snapshot.data!.docs.first['message'] != '') {
                        return Text(
                          '${snapshot.data!.docs.first['username']} : ${snapshot.data!.docs.first['message']}',
                          style: TextStyle(
                              color: ConstantColors.greenColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        );
                      } else {
                        if (snapshot.data!.docs.first['username'] != null &&
                            snapshot.data!.docs.first['message'] == '') {
                          return Text(
                            '${snapshot.data!.docs.first['username']} : sent a sticker',
                            style: TextStyle(
                                color: ConstantColors.greenColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          );
                        } else {
                          return Text('...', style: TextStyle(
                              color: ConstantColors.greenColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)
                          );
                        }
                      }
                    }
                    }
                    else{
                      return Container(width: 0, height: 0,);
                    }
                  },
                ),
                trailing: Container(
                  width: MediaQuery.of(context).size.width*0.2,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('chatrooms')
                    .doc(documentSnapshot.id)
                    .collection('messages')
                    .orderBy('time', descending: true)
                    .snapshots(),
                    builder: (context, snapshot){
                      showLastMessageTime(snapshot.data!.docs.first['time']);
                      if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                      }
                      else {
                        if (getLastestMessageTime != null){
                        return Text(getLastestMessageTime, style: TextStyle(
                          color: ConstantColors.whiteColor.withOpacity(0.4),
                          fontSize: 10,
                          fontWeight: FontWeight.bold
                        ),);
                        }
                        else{
                          return Text('...', style: TextStyle(
                              color: ConstantColors.greenColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)
                          );
                        }
                      }
                    },
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: ConstantColors.transperant,
                  backgroundImage: NetworkImage(documentSnapshot['roomavatar']),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  showLastMessageTime(dynamic timeData){
    Timestamp time = timeData;
    DateTime datetime = time.toDate();
    latestMessageTime = timeago.format(datetime);
    notifyListeners();

  }
}
