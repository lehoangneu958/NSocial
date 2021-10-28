import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/screens/AltProfile/alt_profile.dart';
import 'package:nsocial/screens/HomePage/HomePage.dart';
import 'package:nsocial/services/Authentication.dart';
import 'package:nsocial/services/FirebaseOperations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class GroupMessageHelper with ChangeNotifier {
  bool hasMemberJoined = false;
  bool get getHasMemberJoined => hasMemberJoined;
  late String lastMessageTime;
  String get getLastMessageTime => lastMessageTime;

  late QuerySnapshot querySnapshot;

  cedingAdmin(BuildContext context, String roomName) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
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
                      border: Border.all(color: ConstantColors.whiteColor),
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Text(
                      'Members',
                      style: TextStyle(
                          color: ConstantColors.blueColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(roomName)
                        .collection('members')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return new ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return ListTile(
                              leading: GestureDetector(
                                onTap: () {
                                  if (documentSnapshot.id !=
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid) {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: AltProfile(
                                              userUid: documentSnapshot.id,
                                            ),
                                            type: PageTransitionType
                                                .bottomToTop));
                                  }
                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      documentSnapshot['userimage']),
                                ),
                              ),
                              title: Text(
                                documentSnapshot['username'],
                                style: TextStyle(
                                    color: ConstantColors.blueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              subtitle: Text(
                                documentSnapshot['useremail'],
                                style: TextStyle(
                                    color: ConstantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                              trailing: Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid ==
                                      documentSnapshot.id
                                  ? Container(
                                      width: 0,
                                      height: 0,
                                    )
                                  : MaterialButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('chatrooms')
                                            .doc(roomName)
                                            .update({
                                          'useremail':
                                              documentSnapshot['useremail'],
                                          'userimage':
                                              documentSnapshot['userimage'],
                                          'username':
                                              documentSnapshot['username'],
                                          'useruid': documentSnapshot.id,
                                        }).whenComplete(() {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(documentSnapshot.id)
                                              .collection('chatrooms')
                                              .doc(roomName)
                                              .update({
                                            'useremail':
                                                documentSnapshot['useremail'],
                                            'userimage':
                                                documentSnapshot['userimage'],
                                            'username':
                                                documentSnapshot['username'],
                                            'useruid': documentSnapshot.id,
                                          });
                                        });
                                      },
                                      child: Text(
                                        'Ceding Admin',
                                        style: TextStyle(
                                            color: ConstantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      color: ConstantColors.blueColor,
                                    ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  leaveTheRoomChat(BuildContext context, String chatroomName) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: ConstantColors.darkColor,
            title: Text(
              'Leave $chatroomName ?',
              style: TextStyle(
                  color: ConstantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                      color: ConstantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: ConstantColors.whiteColor,
                      fontSize: 14),
                ),
              ),
              MaterialButton(
                color: ConstantColors.redColor,
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('chatrooms')
                      .doc(chatroomName)
                      .collection('members')
                      .doc(Provider.of<Authentication>(context, listen: false)
                          .getUserUid)
                      .delete()
                      .whenComplete(() {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(Provider.of<Authentication>(context, listen: false)
                            .getUserUid)
                        .collection('chatrooms')
                        .doc(chatroomName)
                        .delete();
                  }).whenComplete(() {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: HomePage(),
                            type: PageTransitionType.bottomToTop));
                  });
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                      color: ConstantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              )
            ],
          );
        });
  }

  deleteTheRoomChat(BuildContext context, String chatroomName) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: ConstantColors.darkColor,
            title: Text(
              'Delete $chatroomName ?',
              style: TextStyle(
                  color: ConstantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                      color: ConstantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: ConstantColors.whiteColor,
                      fontSize: 14),
                ),
              ),
              MaterialButton(
                color: ConstantColors.redColor,
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('chatrooms')
                      .doc(chatroomName)
                      .delete()
                      .whenComplete(() async {
                    querySnapshot = await FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(chatroomName)
                        .collection('members')
                        .get();

                    querySnapshot.docs.forEach((element) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(element.id)
                          .collection('chatrooms')
                          .doc(chatroomName)
                          .delete();
                    });
                  }).whenComplete(() {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: HomePage(),
                            type: PageTransitionType.bottomToTop));
                  });
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                      color: ConstantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              )
            ],
          );
        });
  }

  showMessages(BuildContext context, DocumentSnapshot documentSnapshot,
      String adminUid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(documentSnapshot.id)
          .collection('messages')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return new ListView(
            reverse: true,
            children:
                snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
              showLastMessageTime(documentSnapshot['time']);
              return Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: documentSnapshot['message'] != ''
                      ? MediaQuery.of(context).size.height * 0.15
                      : MediaQuery.of(context).size.height * 0.25,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0, top: 25),
                        child: Row(
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 120,
                                      child: Row(
                                        children: [
                                          Text(
                                            documentSnapshot['username'],
                                            style: TextStyle(
                                                color:
                                                    ConstantColors.greenColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                          documentSnapshot['useruid'] ==
                                                  adminUid
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Icon(
                                                    FontAwesomeIcons.chessKing,
                                                    color: ConstantColors
                                                        .yellowColor,
                                                    size: 12,
                                                  ),
                                                )
                                              : Container(
                                                  width: 0,
                                                  height: 0,
                                                )
                                        ],
                                      ),
                                    ),
                                    (documentSnapshot['message'] != '')
                                        ? Text(
                                            documentSnapshot['message'],
                                            style: TextStyle(
                                                color:
                                                    ConstantColors.whiteColor,
                                                fontSize: 14),
                                          )
                                        : Container(
                                            height: 80,
                                            width: 80,
                                            child: Image.network(
                                                documentSnapshot['sticker'])),
                                    Container(
                                      width: 80,
                                      child: Text(
                                        getLastMessageTime,
                                        style: TextStyle(
                                            color: ConstantColors.whiteColor
                                                .withOpacity(0.4),
                                            fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              constraints: BoxConstraints(
                                  maxHeight: documentSnapshot['message'] != ''
                                      ? MediaQuery.of(context).size.height *
                                          0.15
                                      : MediaQuery.of(context).size.height *
                                          0.3,
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Provider.of<Authentication>(context,
                                                  listen: false)
                                              .getUserUid ==
                                          documentSnapshot['useruid']
                                      ? ConstantColors.blueGreyColor
                                          .withOpacity(0.8)
                                      : ConstantColors.blueGreyColor),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                          top: 15,
                          child: Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserUid ==
                                  documentSnapshot['useruid']
                              ? Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.edit,
                                            color: ConstantColors.blueColor,
                                            size: 16,
                                          )),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            FontAwesomeIcons.trashAlt,
                                            color: ConstantColors.redColor,
                                            size: 12,
                                          )),
                                    ],
                                  ),
                                )
                              : Container(
                                  width: 0,
                                  height: 0,
                                )),
                      Positioned(
                          left: 30,
                          child: Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserUid ==
                                  documentSnapshot['useruid']
                              ? Container(
                                  width: 0.0,
                                  height: 0.0,
                                )
                              : CircleAvatar(
                                  backgroundColor: ConstantColors.darkColor,
                                  backgroundImage: NetworkImage(
                                      documentSnapshot['userimage']),
                                ))
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  sendMessage(BuildContext context, DocumentSnapshot documentSnapshot,
      TextEditingController messageController) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(documentSnapshot.id)
        .collection('messages')
        .add({
      'message': messageController.text,
      'time': Timestamp.now(),
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid
    });
  }

  Future checkIfJoined(BuildContext context, String chatroomName,
      String chatroomAdminUid) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatroomName)
        .collection('members')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((value) {
      hasMemberJoined = false;
      print('Inital state => $hasMemberJoined');
      if (value['joined'] != null) {
        hasMemberJoined = value['joined'];
        print('Final state => $hasMemberJoined');
        notifyListeners();
      }
      if (Provider.of<Authentication>(context, listen: false).getUserUid ==
          chatroomAdminUid) {
        hasMemberJoined = true;
        notifyListeners();
      }
    });
  }

  askToJoin(BuildContext context, String roomName) {
    return showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            backgroundColor: ConstantColors.darkColor,
            title: Text(
              'Join $roomName',
              style: TextStyle(
                  color: ConstantColors.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                      color: ConstantColors.whiteColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: ConstantColors.whiteColor),
                ),
              ),
              MaterialButton(
                color: ConstantColors.blueColor,
                onPressed: () async {
                  FirebaseFirestore.instance
                      .collection('chatrooms')
                      .doc(roomName)
                      .collection('members')
                      .doc(Provider.of<Authentication>(context, listen: false)
                          .getUserUid)
                      .set({
                    'joined': true,
                    'username':
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getInitUserName,
                    'useremail':
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getInitUserEmail,
                    'userimage':
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getInitUserImage,
                    'time': Timestamp.now()
                  }).whenComplete(() {
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: ConstantColors.whiteColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          );
        });
  }

  showSticker(BuildContext context, String chatroomId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.easeIn,
            height: MediaQuery.of(context).size.height * 0.55,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: ConstantColors.darkColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: ConstantColors.whiteColor,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: ConstantColors.blueColor)),
                        height: 30,
                        width: 30,
                        child: Image.asset('assets/icons/sticker_19.png'),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('stickers')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return new Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return new GridView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return GestureDetector(
                                onTap: () {
                                  sendStickers(context,
                                      documentSnapshot['image'], chatroomId);
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  child:
                                      Image.network(documentSnapshot['image']),
                                ),
                              );
                            }).toList(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3));
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  sendStickers(
      BuildContext context, String stickerImageUrl, String chatRoomId) async {
    await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'message': '',
      'sticker': stickerImageUrl,
      'time': Timestamp.now(),
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid
    });
  }

  showLastMessageTime(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    lastMessageTime = timeago.format(dateTime);
    print(lastMessageTime);
    notifyListeners();
  }

  addMembers(BuildContext context, String roomName) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
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
                      border: Border.all(color: ConstantColors.whiteColor),
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Text(
                      'Followers Users',
                      style: TextStyle(
                          color: ConstantColors.blueColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(Provider.of<Authentication>(context, listen: false)
                            .getUserUid)
                        .collection('followers')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return new ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return ListTile(
                              leading: GestureDetector(
                                onTap: () {
                                  if (documentSnapshot['useruid'] !=
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid) {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: AltProfile(
                                              userUid:
                                                  documentSnapshot['useruid'],
                                            ),
                                            type: PageTransitionType
                                                .bottomToTop));
                                  }
                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      documentSnapshot['userimage']),
                                ),
                              ),
                              title: Text(
                                documentSnapshot['username'],
                                style: TextStyle(
                                    color: ConstantColors.blueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              subtitle: Text(
                                documentSnapshot['useremail'],
                                style: TextStyle(
                                    color: ConstantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                              trailing: Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid ==
                                      documentSnapshot['useruid']
                                  ? Container(
                                      width: 0,
                                      height: 0,
                                    )
                                  : MaterialButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('chatrooms')
                                            .doc(roomName)
                                            .collection('members')
                                            .doc(documentSnapshot['useruid'])
                                            .set({
                                          'joined': true,
                                          'username':
                                              documentSnapshot['username'],
                                          'useremail':
                                              documentSnapshot['useremail'],
                                          'userimage':
                                              documentSnapshot['userimage'],
                                          'time': Timestamp.now()
                                        }).whenComplete(() {
                                          Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false)
                                              .submitUserChatRoom(
                                                  roomName,
                                                  {
                                                    'roomavatar': '',
                                                    'time': Timestamp.now(),
                                                    'roomname': roomName,
                                                    'username': Provider.of<
                                                                FirebaseOperations>(
                                                            context,
                                                            listen: false)
                                                        .getInitUserName,
                                                    'useremail': Provider.of<
                                                                FirebaseOperations>(
                                                            context,
                                                            listen: false)
                                                        .getInitUserEmail,
                                                    'userimage': Provider.of<
                                                                FirebaseOperations>(
                                                            context,
                                                            listen: false)
                                                        .getInitUserImage,
                                                    'useruid': Provider.of<
                                                                Authentication>(
                                                            context,
                                                            listen: false)
                                                        .getUserUid,
                                                  },
                                                  documentSnapshot['useruid']);
                                        });
                                      },
                                      child: Text(
                                        'Add User',
                                        style: TextStyle(
                                            color: ConstantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      color: ConstantColors.blueColor,
                                    ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  showDialogAdminLeaveGroup(BuildContext context) {
    return AlertDialog(
      backgroundColor: ConstantColors.darkColor,
      title: Text(
          'Admin can\'t leave the group!!!\nCeding Admin to another member before leave'),
      actions: [
        MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: ConstantColors.blueColor,
            child: Text(
              'Ok',
              style: TextStyle(
                  color: ConstantColors.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ))
      ],
    );
  }
}
