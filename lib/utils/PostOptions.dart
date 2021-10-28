import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/screens/AltProfile/alt_profile.dart';
import 'package:nsocial/services/Authentication.dart';
import 'package:nsocial/services/FirebaseOperations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostFunctions with ChangeNotifier {
  TextEditingController commentController = TextEditingController();
  TextEditingController editCaptionController = TextEditingController();
  late String imageTimePosted;
  String get getimageTimeposted => imageTimePosted;

  Future<bool> checkLike(BuildContext context, String postId) async {
    bool check = false;
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .get();
    List<dynamic> readlData = [];
    data.docs.forEach((element) {
      readlData.add(element);
      // ignore: unnecessary_statements
    });
    readlData.forEach((element) {
      if (element.id ==
          Provider.of<Authentication>(context, listen: false).getUserUid) {
        print("CHeckTrue");
        check = true;
      }
    });
    print('');

    return check;
  }

  showTimeAgo(dynamic timedata) {
    Timestamp time = timedata;
    DateTime dateTime = time.toDate();
    imageTimePosted = timeago.format(dateTime);
    print(imageTimePosted);
    notifyListeners();
  }

  showPostOptions(BuildContext context, String postId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 300,
                                            height: 50,
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintText: 'Add New Caption',
                                                hintStyle: TextStyle(
                                                    color: ConstantColors
                                                        .whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              style: TextStyle(
                                                  color:
                                                      ConstantColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                              controller: editCaptionController,
                                            ),
                                          ),
                                          FloatingActionButton(
                                            onPressed: () {
                                              Provider.of<FirebaseOperations>(
                                                      context,
                                                      listen: false)
                                                  .updateCation(postId, {
                                                'caption':
                                                    editCaptionController.text
                                              });
                                            },
                                            child: Icon(
                                              FontAwesomeIcons.fileUpload,
                                              color: ConstantColors.whiteColor,
                                            ),
                                            backgroundColor:
                                                ConstantColors.redColor,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          color: ConstantColors.blueColor,
                          child: Text(
                            'Edit Caption',
                            style: TextStyle(
                                color: ConstantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: ConstantColors.darkColor,
                                    title: Text(
                                      'Delete this post?',
                                      style: TextStyle(
                                          color: ConstantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    actions: [
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'No',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  ConstantColors.whiteColor,
                                              color: ConstantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false)
                                              .deleteUserPost(postId, 'posts')
                                              .whenComplete(() {
                                            Navigator.pop(context);
                                          });
                                        },
                                        color: ConstantColors.redColor,
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                              color: ConstantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          color: ConstantColors.blueColor,
                          child: Text(
                            'Delete Post',
                            style: TextStyle(
                                color: ConstantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: ConstantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
            ),
          );
        });
  }

  Future addLike(BuildContext context, String postId, String subDocId) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now()
    });
  }

  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment)
        .set({
      'comment': comment,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now()
    });
  }

  showCommentsSheet(
      BuildContext context, DocumentSnapshot snapshot, String docId) {
    return Container(
        child: Padding(
      padding: EdgeInsets.only(bottom: 0),
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 150),
              child: Divider(
                thickness: 4,
                color: ConstantColors.whiteColor,
              ),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //       border: Border.all(color: ConstantColors.whiteColor),
            //       borderRadius: BorderRadius.circular(5)),
            //   child: Center(
            //     child: Text(
            //       'Comments',
            //       style: TextStyle(
            //           color: ConstantColors.blueColor,
            //           fontSize: 16,
            //           fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.35,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(docId)
                    .collection('comments')
                    .orderBy('time')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return new ListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot documentSnapshot) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 8, left: 8),
                                    child: GestureDetector(
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
                                            ConstantColors.darkColor,
                                        radius: 15,
                                        backgroundImage: NetworkImage(
                                            documentSnapshot['userimage']),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              documentSnapshot['username'],
                                              style: TextStyle(
                                                  color:
                                                      ConstantColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              FontAwesomeIcons.arrowUp,
                                              color: ConstantColors.blueColor,
                                              size: 14,
                                            )),
                                        Text(
                                          '0',
                                          style: TextStyle(
                                              color: ConstantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              FontAwesomeIcons.reply,
                                              color: ConstantColors.yellowColor,
                                              size: 14,
                                            )),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: ConstantColors.blueColor,
                                          size: 12,
                                        )),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Text(
                                        documentSnapshot['comment'],
                                        style: TextStyle(
                                            color: ConstantColors.whiteColor,
                                            fontSize: 14),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          FontAwesomeIcons.trashAlt,
                                          color: ConstantColors.redColor,
                                          size: 14,
                                        )),
                                  ],
                                ),
                              ),
                              // Divider(
                              //   color: ConstantColors.darkColor.withOpacity(0.2),
                              // )
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: ConstantColors.blueGreyColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0), topRight: Radius.circular(0))),
      ),
    ));
  }

  showLikes(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
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
                      'Likes',
                      style: TextStyle(
                          color: ConstantColors.blueColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('likes')
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
                                      onPressed: () {},
                                      child: Text(
                                        'Follow',
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
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: ConstantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
          );
        });
  }
}
