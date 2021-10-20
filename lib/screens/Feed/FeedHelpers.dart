import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/screens/AltProfile/alt_profile.dart';
import 'package:nsocial/screens/Feed/Comment.dart';

import 'package:nsocial/services/Authentication.dart';
import 'package:nsocial/utils/PostOptions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class FeedHelpers with ChangeNotifier {
  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SizedBox(
                    height: 500,
                    width: MediaQuery.of(context).size.width,
                    child: Lottie.asset('assets/animations/loading.json'),
                  ),
                );
              } else {
                return ListView(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot documentSnapshot) {
                    Provider.of<PostFunctions>(context, listen: false)
                        .showTimeAgo(documentSnapshot['time']);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: ConstantColors.blueColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(15)),
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 8),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (documentSnapshot['useruid'] !=
                                          Provider.of<Authentication>(context,
                                                  listen: false)
                                              .getUserUid) {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                child: AltProfile(
                                                  userUid: documentSnapshot[
                                                      'useruid'],
                                                ),
                                                type: PageTransitionType
                                                    .bottomToTop));
                                      }
                                    },
                                    child: CircleAvatar(
                                      backgroundColor:
                                          ConstantColors.transperant,
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                          documentSnapshot['userimage']),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              child: RichText(
                                                  text: TextSpan(
                                            text: documentSnapshot['username'],
                                            style: TextStyle(
                                                color: ConstantColors.blueColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ))),
                                          RichText(
                                              text: TextSpan(
                                                  text:
                                                      '${Provider.of<PostFunctions>(context, listen: false).getimageTimeposted.toString()}',
                                                  style: TextStyle(
                                                      color: ConstantColors
                                                          .lightColor
                                                          .withOpacity(1))))
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Text(
                                  documentSnapshot['caption'],
                                  style: TextStyle(
                                      color: ConstantColors.greenColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            Container(
                              color: ConstantColors.transperant,
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width,
                              child: FittedBox(
                                child: Image.network(
                                    documentSnapshot['postimage'],
                                    scale: 2),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  //---------heart
                                  Container(
                                    width: 80,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onLongPress: () {
                                            Provider.of<PostFunctions>(context,
                                                    listen: false)
                                                .showLikes(
                                                    context,
                                                    documentSnapshot[
                                                        'caption']);
                                          },
                                          onTap: () {
                                            print('Adding Like...');
                                            Provider.of<PostFunctions>(context,
                                                    listen: false)
                                                .addLike(
                                                    context,
                                                    documentSnapshot['caption'],
                                                    Provider.of<Authentication>(
                                                            context,
                                                            listen: false)
                                                        .getUserUid);
                                          },
                                          child: Icon(
                                            FontAwesomeIcons.heart,
                                            color: ConstantColors.redColor,
                                            size: 22,
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left: 8)),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('posts')
                                              .doc(documentSnapshot['caption'])
                                              .collection('likes')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else {
                                              return Text(
                                                snapshot.data!.docs.length
                                                    .toString(),
                                                style: TextStyle(
                                                    color: ConstantColors
                                                        .whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              );
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  //------comment
                                  Container(
                                    width: 80,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    child: Comment(
                                                        postId:
                                                            documentSnapshot[
                                                                'caption']),
                                                    type: PageTransitionType
                                                        .rightToLeft));
                                          },
                                          child: Icon(
                                            FontAwesomeIcons.comment,
                                            color: ConstantColors.blueColor,
                                            size: 22,
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left: 8)),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('posts')
                                              .doc(documentSnapshot['caption'])
                                              .collection('comments')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else {
                                              return Text(
                                                snapshot.data!.docs.length
                                                    .toString(),
                                                style: TextStyle(
                                                    color: ConstantColors
                                                        .whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              );
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  //--------award
                                  Container(
                                    width: 80,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          child: Icon(
                                            FontAwesomeIcons.award,
                                            color: ConstantColors.yellowColor,
                                            size: 22,
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left: 8)),
                                        Text(
                                          '0',
                                          style: TextStyle(
                                              color: ConstantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        )
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Provider.of<Authentication>(context,
                                                  listen: false)
                                              .getUserUid ==
                                          documentSnapshot['useruid']
                                      ? IconButton(
                                          onPressed: () {
                                            Provider.of<PostFunctions>(context,
                                                    listen: false)
                                                .showPostOptions(
                                                    context,
                                                    documentSnapshot[
                                                        'caption']);
                                          },
                                          icon: Icon(
                                            EvaIcons.moreVertical,
                                            color: ConstantColors.whiteColor,
                                          ))
                                      : Container(
                                          width: 0.0,
                                          height: 0.0,
                                        )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: ConstantColors.darkColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        ),
      ),
    );
  }
}
