import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/screens/AltProfile/alt_profile.dart';

import 'package:nsocial/services/Authentication.dart';
import 'package:nsocial/services/FirebaseOperations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AltprofileHelper with ChangeNotifier {
  Widget headerProfile(
      BuildContext context, DocumentSnapshot snapshot, String userUid) {
    return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundColor: ConstantColors.transperant,
                    backgroundImage: NetworkImage(snapshot['userimage']),
                    radius: 40,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot['username'],
                        style: TextStyle(
                          color: ConstantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            EvaIcons.email,
                            color: ConstantColors.whiteColor,
                          ),
                          Text(
                            snapshot['useremail'],
                            style: TextStyle(
                                color: ConstantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Divider(
          color: ConstantColors.whiteColor,
        ),
      ),
      Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (){
                    checkFollowSheet(context, snapshot, 'followers');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Column(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(snapshot['useruid'])
                              .collection('followers')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return new Text(
                                snapshot.data!.docs.length.toString(),
                                style: TextStyle(
                                    color: ConstantColors.whiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              );
                            }
                          },
                        ),
                        Text(
                          'Followers',
                          style: TextStyle(
                              color: ConstantColors.whiteColor, fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    checkFollowSheet(context, snapshot, 'following');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Column(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(snapshot['useruid'])
                              .collection('following')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return new Text(
                                snapshot.data!.docs.length.toString(),
                                style: TextStyle(
                                    color: ConstantColors.whiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              );
                            }
                          },
                        ),
                        Text(
                          'Following',
                          style: TextStyle(
                              color: ConstantColors.whiteColor, fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Column(
                    children: [
                      Text(
                        '0',
                        style: TextStyle(
                            color: ConstantColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Post',
                        style: TextStyle(
                            color: ConstantColors.whiteColor, fontSize: 14),
                      )
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .followUser(
                                userUid,
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid,
                                {
                                  'username': Provider.of<FirebaseOperations>(
                                          context,
                                          listen: false)
                                      .getInitUserName,
                                  'userimage': Provider.of<FirebaseOperations>(
                                          context,
                                          listen: false)
                                      .getInitUserImage,
                                  'useruid': Provider.of<Authentication>(
                                          context,
                                          listen: false)
                                      .getUserUid,
                                  'useremail': Provider.of<FirebaseOperations>(
                                          context,
                                          listen: false)
                                      .getInitUserEmail,
                                  'time': Timestamp.now()
                                },
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid,
                                userUid,
                                {
                                  'username': snapshot['username'],
                                  'userimage': snapshot['userimage'],
                                  'useremail': snapshot['useremail'],
                                  'useruid': snapshot['useruid'],
                                  'time': Timestamp.now()
                                })
                            .whenComplete(() {
                          followedNotification(context, snapshot['username']);
                        });
                      },
                      color: ConstantColors.blueColor,
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.check,
                            color: ConstantColors.whiteColor,
                            size: 16,
                          ),
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Text(
                            'Follow',
                            style: TextStyle(
                                color: ConstantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {},
                      color: ConstantColors.blueColor,
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.comments,
                            color: ConstantColors.whiteColor,
                            size: 16,
                          ),
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Text(
                            'Message',
                            style: TextStyle(
                                color: ConstantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Divider(
          color: ConstantColors.whiteColor.withOpacity(0.5),
        ),
      ),
    ]));
  }

  Widget middleProfile(BuildContext context, dynamic snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(2)),
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 12)),
                    Icon(
                      FontAwesomeIcons.userPlus,
                      color: ConstantColors.yellowColor,
                      size: 16,
                    ),
                    Padding(padding: EdgeInsets.only(left: 8)),
                    Text(
                      'Recently Added',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: ConstantColors.whiteColor),
                    )
                  ],
                ),
              ),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(snapshot['useruid'])
                      .collection('following')
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: GestureDetector(
                                onTap: (){
                                  if (documentSnapshot['useruid'] != Provider.of<Authentication>(context, listen: false)
                              .getUserUid){
                                Navigator.pushReplacement(context, PageTransition(
                                  child: AltProfile(userUid:documentSnapshot['useruid']), type: PageTransitionType.topToBottom
                                ));
                                }
                                },
                                child: new CircleAvatar(
                                  
                                                  backgroundColor: ConstantColors.transperant,
                                                  backgroundImage: NetworkImage(documentSnapshot['userimage']),
                                                  radius: 25,
                                                ),
                              ),
                            );
                          }
                        }).toList(),
                      );
                    }
                  },
                ),
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: ConstantColors.darkColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(5)),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        child: Image.asset('assets/images/empty.png'),
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: ConstantColors.darkColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  followedNotification(BuildContext context, String name) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: ConstantColors.whiteColor,
                  ),
                ),
                Text(
                  'Followed $name',
                  style: TextStyle(
                      color: ConstantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: ConstantColors.darkColor,
                borderRadius: BorderRadius.circular(12)),
          );
        });
  }
  checkFollowSheet(BuildContext context, dynamic snapshot, String follow){
    return showModalBottomSheet(context: context, builder: (context){
      return Container(
        height: MediaQuery.of(context).size.height*0.4,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: ConstantColors.blueGreyColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
        ),
        child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(snapshot['useruid'])
                      .collection(follow)
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return new ListTile(
                              onTap: (){
                                if (documentSnapshot['useruid'] != Provider.of<Authentication>(context, listen: false)
                              .getUserUid){
                                Navigator.pushReplacement(context, PageTransition(
                                  child: AltProfile(userUid:documentSnapshot['useruid']), type: PageTransitionType.topToBottom
                                ));
                              }
                              },
                              trailing: follow == 'following' ? 
                              documentSnapshot['useruid'] == Provider.of<Authentication>(context)
                              .getUserUid ? Container(
                                width: 0,
                                height: 0,
                              ) : 
                              MaterialButton(
                                onPressed: (){},
                                color: ConstantColors.blueColor,
                                // child: Row(
                                //   children: [
                                    // Icon(FontAwesomeIcons.times),
                                    // Padding(padding: EdgeInsets.only(left: 8)),
                                child:    Text('Unfollow', style: TextStyle(
                                      color: ConstantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                    ),),
                                  // ],
                                ) :
                                Container(width: 0, height: 0,),
                              
                              leading: CircleAvatar(
                                backgroundColor: ConstantColors.darkColor,
                                backgroundImage: NetworkImage(
                                  documentSnapshot['userimage']
                                ),
                              ),
                              title: Text(documentSnapshot['username'],
                              style: TextStyle(
                                color: ConstantColors.blueColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),),
                              subtitle: Text(documentSnapshot['useremail'],
                              style: TextStyle(
                                color: ConstantColors.whiteColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold
                              ),),
                            );
                          }
                        }).toList(),
                      );
                    }
                  },
                ),
      );
    });
  }
}
