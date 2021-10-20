import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/screens/AltProfile/alt_profile.dart';
import 'package:nsocial/screens/landingPage/landingPage.dart';
import 'package:nsocial/services/Authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ProfileHelpers with ChangeNotifier {
  Widget headerProfile(BuildContext context, DocumentSnapshot snapshot) {
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
                )
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
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
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
                                  Navigator.push(context, PageTransition(
                                  child: AltProfile(userUid:documentSnapshot['useruid']), type: PageTransitionType.topToBottom
                                ));
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
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        child: Image.asset('assets/images/empty.png'),
        height: MediaQuery.of(context).size.height * 0.55,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: ConstantColors.darkColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  logOutDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: ConstantColors.darkColor,
            title: Text(
              'Log Out?',
              style: TextStyle(
                  color: ConstantColors.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              MaterialButton(
                  child: Text(
                    'No',
                    style: TextStyle(
                        color: ConstantColors.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: ConstantColors.whiteColor),
                  ),
                  onPressed: () {}),
              MaterialButton(
                  color: ConstantColors.redColor,
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: ConstantColors.whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Provider.of<Authentication>(context, listen: false)
                        .logOutviaEmail()
                        .whenComplete(() => {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: LandingPage(),
                                      type: PageTransitionType.bottomToTop))
                            });
                  })
            ],
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
                                Navigator.pushReplacement(context, PageTransition(
                                  child: AltProfile(userUid:documentSnapshot['useruid']), type: PageTransitionType.topToBottom
                                ));
                              },
                              trailing: follow == 'following' ? MaterialButton(
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
                                ) : Container(width: 0,height: 0,) ,
                              
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
