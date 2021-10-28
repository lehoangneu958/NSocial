import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/screens/HomePage/HomePage.dart';
import 'package:nsocial/services/Authentication.dart';
import 'package:nsocial/services/FirebaseOperations.dart';
import 'package:provider/provider.dart';

class UploadPost with ChangeNotifier {
  TextEditingController captionController = TextEditingController();
  late File uploadPostImage;
  File get getUploadPostImage => uploadPostImage;
  String uploadPostImageUrl = '';
  String get getUploadPostImageUrl => uploadPostImageUrl;
  final picker = ImagePicker();

  late UploadTask imagePostUploadTask;
  int count = 0;
  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal = await picker.getImage(source: source);
    uploadPostImageVal == null
        ? print("Select image")
        : uploadPostImage = File(uploadPostImageVal.path);
    print(uploadPostImage.path);

    uploadPostImage != null
        ? showPostImage(context)
        : print('Image upload error');

    notifyListeners();
  }

  Future uploadPostImageToFirebase() async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${uploadPostImage.path}/${TimeOfDay.now()}');

    imagePostUploadTask = imageReference.putFile(uploadPostImage);
    await imagePostUploadTask
        .whenComplete(() => {print('Post Image uploaded to Storage')});

    imageReference.getDownloadURL().then((imageUrl) =>
        {uploadPostImageUrl = imageUrl, print(uploadPostImageUrl)});
    notifyListeners();
  }

  selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: ConstantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: ConstantColors.whiteColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: ConstantColors.blueColor,
                        child: Text(
                          'Galery',
                          style: TextStyle(
                              color: ConstantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        onPressed: () {
                          pickUploadPostImage(context, ImageSource.gallery);
                        }),
                    MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: ConstantColors.redColor,
                        child: Text(
                          'Camera',
                          style: TextStyle(
                              color: ConstantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        onPressed: () {
                          pickUploadPostImage(context, ImageSource.camera);
                        })
                  ],
                )
              ],
            ),
          );
        });
  }

  showPostImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: ConstantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: ConstantColors.whiteColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                  child: Container(
                    height: 200,
                    width: 400,
                    child: Image.file(
                      uploadPostImage,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                        child: Text(
                          'Reselect',
                          style: TextStyle(
                              color: ConstantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: ConstantColors.whiteColor),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          selectPostImageType(context);
                        }),
                    MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: ConstantColors.blueColor,
                        child: Text(
                          'Confirm Image',
                          style: TextStyle(
                            color: ConstantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          uploadPostImageToFirebase().whenComplete(() => {
                                editPostSheet(context),
                                print('Image uploaded')
                              });
                        })
                  ],
                )
              ],
            ),
          );
        });
  }

  editPostSheetWithoutImage(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Container(
                      //   child: Column(
                      //     children: [
                      //       IconButton(
                      //           onPressed: () {},
                      //           icon: Icon(
                      //             Icons.image_aspect_ratio,
                      //             color: ConstantColors.greenColor,
                      //           )),
                      //       IconButton(
                      //           onPressed: () {},
                      //           icon: Icon(
                      //             Icons.fit_screen,
                      //             color: ConstantColors.yellowColor,
                      //           ))
                      //     ],
                      //   ),
                      // ),
                      Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            // height: 10,
                            // width: 10,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ConstantColors.whiteColor),
                            child: Center(
                              child: IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.plus,
                                  size: 20,
                                  color: ConstantColors.greyColor,
                                ),
                                onPressed: () {
                                  selectPostImageType(context);
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 30,
                        width: MediaQuery.of(context).size.width * 0.05,
                        child: Image.asset('assets/icons/sunflower.png'),
                      ),
                      Container(
                        height: 110,
                        width: 5,
                        color: ConstantColors.blueColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          height: 120,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextField(
                            maxLines: 5,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100)
                            ],
                            maxLength: 100,
                            maxLengthEnforced: true,
                            controller: captionController,
                            style: TextStyle(
                                color: ConstantColors.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              hintText: 'Add ad Caption...',
                              hintStyle: TextStyle(
                                  color: ConstantColors.whiteColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                MaterialButton(
                  child: Text('Share'),
                  onPressed: () async {
                    Provider.of<FirebaseOperations>(context, listen: false)
                        .uploadPostData({
                      'postimage': '',
                      'caption': captionController.text,
                      'username': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getInitUserName,
                      'userimage': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getInitUserImage,
                      'useruid':
                          Provider.of<Authentication>(context, listen: false)
                              .getUserUid,
                      'time': Timestamp.now(),
                      'useremail': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getInitUserEmail,
                    }).whenComplete(() => {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                  (route) => false)
                            });
                  },
                  color: ConstantColors.blueColor,
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: ConstantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12)),
          );
        });
  }

  editPostSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Container(
                      //   child: Column(
                      //     children: [
                      //       IconButton(
                      //           onPressed: () {},
                      //           icon: Icon(
                      //             Icons.image_aspect_ratio,
                      //             color: ConstantColors.greenColor,
                      //           )),
                      //       IconButton(
                      //           onPressed: () {},
                      //           icon: Icon(
                      //             Icons.fit_screen,
                      //             color: ConstantColors.yellowColor,
                      //           ))
                      //     ],
                      //   ),
                      // ),
                      Container(
                          height: 200,
                          width: 300,
                          child: Image.file(
                            uploadPostImage,
                            fit: BoxFit.contain,
                          ))
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 30,
                        width: MediaQuery.of(context).size.width * 0.05,
                        child: Image.asset('assets/icons/sunflower.png'),
                      ),
                      Container(
                        height: 110,
                        width: 5,
                        color: ConstantColors.blueColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          height: 120,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextField(
                            maxLines: 5,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100)
                            ],
                            maxLength: 100,
                            maxLengthEnforced: true,
                            controller: captionController,
                            style: TextStyle(
                                color: ConstantColors.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              hintText: 'Add ad Caption...',
                              hintStyle: TextStyle(
                                  color: ConstantColors.whiteColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                MaterialButton(
                  child: Text('Share'),
                  onPressed: () async {
                    Provider.of<FirebaseOperations>(context, listen: false)
                        .uploadPostData({
                      'postimage': getUploadPostImageUrl,
                      'caption': captionController.text,
                      'username': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getInitUserName,
                      'userimage': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getInitUserImage,
                      'useruid':
                          Provider.of<Authentication>(context, listen: false)
                              .getUserUid,
                      'time': Timestamp.now(),
                      'useremail': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getInitUserEmail,
                    }).whenComplete(() => {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                  (route) => false)
                            });
                  },
                  color: ConstantColors.blueColor,
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: ConstantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12)),
          );
        });
  }
}
