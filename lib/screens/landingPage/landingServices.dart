import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/screens/HomePage/HomePage.dart';
import 'package:nsocial/screens/landingPage/landingUtils.dart';
import 'package:nsocial/services/Authentication.dart';
import 'package:nsocial/services/FirebaseOperations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LandingServices with ChangeNotifier {
  TextEditingController UserEmailController = TextEditingController();
  TextEditingController UserNameController = TextEditingController();
  TextEditingController UserPasswordController = TextEditingController();

  showUserAvatar(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
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
                CircleAvatar(
                  radius: 60,
                  backgroundColor: ConstantColors.transperant,
                  backgroundImage: FileImage(
                      Provider.of<LandingUtils>(context, listen: false)
                          .userAvatar),
                ),
                Container(
                  child: Row(
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
                            Provider.of<LandingUtils>(context, listen: false)
                                .pickUserAvatar(context, ImageSource.gallery);
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
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .uploadUserAvatar(context)
                                .whenComplete(() => {signInSheet(context)});
                          })
                    ],
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
              color: ConstantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(15),
            ),
          );
        });
  }

  Widget passwordLessSignIn(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return new ListView(
              children:
                  snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                return ListTile(
                  trailing: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.trashAlt,
                      color: ConstantColors.redColor,
                    ),
                    onPressed: () {},
                  ),
                  leading: CircleAvatar(
                    backgroundColor: ConstantColors.transperant,
                    backgroundImage:
                        NetworkImage(documentSnapshot['userimage']),
                  ),
                  subtitle: Text(
                    documentSnapshot['useremail'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ConstantColors.greenColor),
                  ),
                  title: Text(
                    documentSnapshot['username'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ConstantColors.greenColor),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  logInSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
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
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: UserEmailController,
                        decoration: InputDecoration(
                          hintText: 'Enter email...',
                          hintStyle: TextStyle(
                              color: ConstantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        style: TextStyle(
                            color: ConstantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: UserPasswordController,
                        decoration: InputDecoration(
                          hintText: 'Enter password...',
                          hintStyle: TextStyle(
                              color: ConstantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        style: TextStyle(
                            color: ConstantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: FloatingActionButton(
                          backgroundColor: ConstantColors.blueColor,
                          child: Icon(
                            FontAwesomeIcons.check,
                            color: ConstantColors.whiteColor,
                          ),
                          onPressed: () {
                            if (UserEmailController.text.isNotEmpty) {
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .logIntoAccount(
                                      context,
                                      UserEmailController.text,
                                      UserPasswordController.text)
                                  .whenComplete(() => {});
                            } else {
                              warningText(context, 'Fill all the data!');
                            }
                          }),
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                  color: ConstantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
            ),
          );
        });
  }

  signInSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 150),
                      child: Divider(
                        thickness: 4,
                        color: ConstantColors.whiteColor,
                      ),
                    ),
                    CircleAvatar(
                      backgroundImage: FileImage(
                          Provider.of<LandingUtils>(context, listen: false)
                              .getUserAvatar),
                      backgroundColor: ConstantColors.redColor,
                      radius: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: UserNameController,
                        decoration: InputDecoration(
                          hintText: 'Enter name...',
                          hintStyle: TextStyle(
                              color: ConstantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        style: TextStyle(
                            color: ConstantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: UserEmailController,
                        decoration: InputDecoration(
                          hintText: 'Enter email...',
                          hintStyle: TextStyle(
                              color: ConstantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        style: TextStyle(
                            color: ConstantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: UserPasswordController,
                        decoration: InputDecoration(
                          hintText: 'Enter password...',
                          hintStyle: TextStyle(
                              color: ConstantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        style: TextStyle(
                            color: ConstantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: FloatingActionButton(
                          backgroundColor: ConstantColors.redColor,
                          child: Icon(
                            FontAwesomeIcons.check,
                            color: ConstantColors.whiteColor,
                          ),
                          onPressed: () {
                            if (UserEmailController.text.isNotEmpty) {
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .createAccount(UserEmailController.text,
                                      UserPasswordController.text)
                                  .whenComplete(() => {
                                        print('Creating collection'),
                                        Provider.of<FirebaseOperations>(context,
                                                listen: false)
                                            .createUserCollection(context, {
                                          'userpassword':
                                              UserPasswordController.text,
                                          'useruid':
                                              Provider.of<Authentication>(
                                                      context,
                                                      listen: false)
                                                  .getUserUid,
                                          'useremail': UserEmailController.text,
                                          'username': UserNameController.text,
                                          'userimage':
                                              Provider.of<LandingUtils>(context,
                                                      listen: false)
                                                  .getUserAvatarUrl,
                                        })
                                      })
                                  .whenComplete(() => {
                                        Navigator.pushReplacement(
                                            context,
                                            PageTransition(
                                                child: HomePage(),
                                                type: PageTransitionType
                                                    .bottomToTop))
                                      });
                              ;
                            } else {
                              warningText(context, 'Fill all the data!');
                            }
                          }),
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                  color: ConstantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
            ),
          );
        });
  }

  warningText(BuildContext context, String warning) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: ConstantColors.darkColor,
                borderRadius: BorderRadius.circular(15)),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                warning,
                style: TextStyle(
                    color: ConstantColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        });
  }
}
