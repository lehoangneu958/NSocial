import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/screens/AltProfile/alt_profile.dart';
import 'package:nsocial/screens/Feed/FeedHelpers.dart';
import 'package:nsocial/screens/HomePage/HomePage.dart';
import 'package:nsocial/services/Authentication.dart';
import 'package:nsocial/utils/PostOptions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Comment extends StatelessWidget {
  TextEditingController commentController = TextEditingController();
  final String postId;
  Comment({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: ConstantColors.whiteColor,
          ),
          onPressed: () {
            // Navigator.pushReplacement(context, PageTransition(child: HomePage(),
            // type: PageTransitionType.bottomToTop));
            Navigator.pop(context);
          },
        ),
        backgroundColor: ConstantColors.blueGreyColor,
        actions: [
          IconButton(
            icon: Icon(
              EvaIcons.moreVertical,
              color: ConstantColors.whiteColor,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: HomePage(), type: PageTransitionType.bottomToTop));
            },
          ),
        ],
        centerTitle: true,
        title: RichText(
            text: TextSpan(
                text: 'Com',
                style: TextStyle(
                    color: ConstantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                children: <TextSpan>[
              TextSpan(
                  text: 'ment',
                  style: TextStyle(
                      color: ConstantColors.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20))
            ])),
      ),
      body: SingleChildScrollView(
          child: Container(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(postId)
              .snapshots(),
          builder: (context, snapshot) {
            Provider.of<PostFunctions>(context, listen: false)
                .showTimeAgo(snapshot.data!['time']);
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return Center(
            //     child: SizedBox(
            //       height: 500,
            //       width: MediaQuery.of(context).size.width,
            //       child: Lottie.asset('assets/animations/loading.json'),
            //     ),
            //   );
            // } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: ConstantColors.blueColor.withOpacity(0.3),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    // height: MediaQuery.of(context).size.height * 0.6,
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
                                  if (snapshot.data!['useruid'] !=
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid) {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: AltProfile(
                                              userUid:
                                                  snapshot.data!['useruid'],
                                            ),
                                            type: PageTransitionType
                                                .bottomToTop));
                                  }
                                },
                                child: CircleAvatar(
                                  backgroundColor: ConstantColors.transperant,
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(snapshot.data!['userimage']),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          child: RichText(
                                              text: TextSpan(
                                        text: snapshot.data!['username'],
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
                              snapshot.data!['caption'],
                              style: TextStyle(
                                  color: ConstantColors.greenColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                        snapshot.data!['postimage'] != ''
                            ? Container(
                                color: ConstantColors.transperant,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width,
                                child: FittedBox(
                                  child: Image.network(
                                      snapshot.data!['postimage'],
                                      scale: 2),
                                ),
                              )
                            : Container(
                                width: 0,
                                height: 0,
                              ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              //---------heart
                              Container(
                                width: 80,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onLongPress: () {
                                        Provider.of<PostFunctions>(context,
                                                listen: false)
                                            .showLikes(context,
                                                snapshot.data!['caption']);
                                      },
                                      onTap: () {
                                        print('Adding Like...');
                                        Provider.of<PostFunctions>(context,
                                                listen: false)
                                            .addLike(
                                                context,
                                                snapshot.data!['caption'],
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
                                    Padding(padding: EdgeInsets.only(left: 8)),
                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(postId)
                                          .collection('likes')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          return Text(
                                            snapshot.data!.docs.length
                                                .toString(),
                                            style: TextStyle(
                                                color:
                                                    ConstantColors.whiteColor,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Provider.of<PostFunctions>(context,
                                        //         listen: false)
                                        //     .showCommentsSheet(
                                        //         context,
                                        //         snapshot.data!,
                                        //         snapshot.data!['caption']);
                                      },
                                      child: Icon(
                                        FontAwesomeIcons.comment,
                                        color: ConstantColors.blueColor,
                                        size: 22,
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.only(left: 8)),
                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(snapshot.data!['caption'])
                                          .collection('comments')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          return Text(
                                            snapshot.data!.docs.length
                                                .toString(),
                                            style: TextStyle(
                                                color:
                                                    ConstantColors.whiteColor,
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
                              // Container(
                              //   width: 80,
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     children: [
                              //       GestureDetector(
                              //         child: Icon(
                              //           FontAwesomeIcons.award,
                              //           color: ConstantColors.yellowColor,
                              //           size: 22,
                              //         ),
                              //       ),
                              //       Padding(padding: EdgeInsets.only(left: 8)),
                              //       Text(
                              //         '0',
                              //         style: TextStyle(
                              //             color: ConstantColors.whiteColor,
                              //             fontWeight: FontWeight.bold,
                              //             fontSize: 18),
                              //       )
                              //     ],
                              //   ),
                              // ),
                              Spacer(),
                              Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid ==
                                      snapshot.data!['useruid']
                                  ? IconButton(
                                      onPressed: () {
                                        Provider.of<PostFunctions>(context,
                                                listen: false)
                                            .showPostOptions(context, postId);
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
                        Padding(padding: EdgeInsets.only(bottom: 8)),
                      ],
                    ),
                  ),
                ),
                Provider.of<PostFunctions>(context, listen: false)
                    .showCommentsSheet(context, snapshot.data!, postId),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: ConstantColors.blueGreyColor,
                  // height: MediaQuery.of(context).size.height * 0.2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                              hintText: 'Add Comment...',
                              hintStyle: TextStyle(
                                  color: ConstantColors.whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          controller: commentController,
                          style: TextStyle(
                              color: ConstantColors.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          print('Adding Comment...');
                          Provider.of<PostFunctions>(context, listen: false)
                              .addComment(
                                  context, postId, commentController.text)
                              .whenComplete(() {
                            commentController.clear();
                          });
                        },
                        child: Icon(
                          FontAwesomeIcons.paperPlane,
                          color: ConstantColors.whiteColor,
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
            //}
          },
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: ConstantColors.darkColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      )),
    );
  }
}
