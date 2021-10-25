import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/services/Authentication.dart';
import 'package:nsocial/services/FirebaseOperations.dart';
import 'package:provider/provider.dart';

class ChatroomHelper with ChangeNotifier {
  late String chatroomAvatarUrl, chatroomID;
  String get getChatroomID => chatroomID;
  final TextEditingController chatroomNameController = TextEditingController();
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
                            Provider.of<FirebaseOperations>(context, listen: false)
                            .submitChatroomData(chatroomNameController.text
                            , {
                                'roomavatar': '',
                                'time': Timestamp.now(),
                                'roomname': chatroomNameController.text,
                                'username': Provider.of<FirebaseOperations>(context, listen: false)
                                .getInitUserName,
                                'useremail': Provider.of<FirebaseOperations>(context, listen: false)
                                .getInitUserEmail,
                                'userimage': Provider.of<FirebaseOperations>(context, listen: false)
                                .getInitUserImage,
                                'useruid': Provider.of<Authentication>(context, listen: false)
                                .getUserUid,
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

  showChatrooms(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chatrooms').snapshots(),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        else{
          return new ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot){
              return ListTile(
                title: Text(documentSnapshot['roomname'],
                style: TextStyle(
                  color: ConstantColors.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),),
                subtitle: Text('Last Message',
                style: TextStyle(
                  color: ConstantColors.greenColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
                ),),
                trailing: Text('2 hours ago', style: TextStyle(
                  color: ConstantColors.greenColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
                ),),
                leading: CircleAvatar(
                  backgroundColor: ConstantColors.transperant,
                  backgroundImage: NetworkImage(
                    documentSnapshot['roomavatar']
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
