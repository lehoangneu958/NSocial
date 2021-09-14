import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/screens/HomePage/HomePage.dart';
import 'package:nsocial/screens/landingPage/landingServices.dart';
import 'package:nsocial/screens/landingPage/landingUtils.dart';
import 'package:nsocial/services/Authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LandingHelpers with ChangeNotifier {
  Widget bodyImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/login.png'))),
    );
  }

  Widget taglineText(BuildContext context) {
    return Positioned(
        top: MediaQuery.of(context).size.height * 0.6,
        left: 10,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 170,
          ),
          child: RichText(
              text: TextSpan(
                  text: 'Are ',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: ConstantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                  children: <TextSpan>[
                TextSpan(
                  text: 'You ',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: ConstantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 34),
                ),
                TextSpan(
                  text: 'Social?',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: ConstantColors.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 34),
                )
              ])),
        ));
  }

  Widget mainButton(BuildContext context) {
    return Positioned(
        top: MediaQuery.of(context).size.height * 0.8,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: (){
                  emailAuthSheet(context);
                },
                child: Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: ConstantColors.yellowColor),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    EvaIcons.emailOutline,
                    color: ConstantColors.yellowColor,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  print('Signing with google');
                  Provider.of<Authentication>(context, listen: false)
                      .signInWithGoogle()
                      .whenComplete(() {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: HomePage(),
                            type: PageTransitionType.leftToRight));
                  });
                },
                child: Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: ConstantColors.redColor),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    FontAwesomeIcons.google,
                    color: ConstantColors.redColor,
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: ConstantColors.blueColor),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    FontAwesomeIcons.facebookF,
                    color: ConstantColors.blueColor,
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget privacyText(BuildContext context) {
    return Positioned(
        top: MediaQuery.of(context).size.height * 0.92,
        left: 20,
        right: 20,
        child: Container(
          child: Column(
            children: [
              Text(
                "By countinuing you agree NSocial's Terms of",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              Text(
                "Services & Privacy Policy",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              )
            ],
          ),
        ));
  }

  emailAuthSheet(BuildContext context) {
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
                SizedBox(),
                Provider.of<LandingServices>(context, listen: false).passwordLessSignIn(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: ConstantColors.blueColor,
                      onPressed: () {
                        Provider.of<LandingServices>(context, listen: false).logInSheet(context);
                      },
                      child: Text(
                        'Log In',
                        style: TextStyle(
                            color: ConstantColors.whiteColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: ConstantColors.redColor,
                      onPressed: () {
                        Provider.of<LandingUtils>(context, listen: false).selectAvatarOptionsSheet(context);
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                            color: ConstantColors.whiteColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: ConstantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
          );
        });
  }
}
