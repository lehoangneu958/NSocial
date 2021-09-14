

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/screens/landingPage/landingPage.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 2),
      () => Navigator.pushReplacement(context, PageTransition(child: LandingPage(), type: PageTransitionType.leftToRight)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.darkColor,
      body: Center(child: RichText(text: TextSpan(
        text: 'N',
        style: TextStyle(
          fontFamily: 'Poppins',
          color: ConstantColors.whiteColor,
          fontWeight: FontWeight.bold,
          fontSize: 30
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'Social',
            style: TextStyle(
          fontFamily: 'Poppins',
          color: ConstantColors.blueColor,
          fontWeight: FontWeight.bold,
          fontSize: 34
        ),
          )
        ]
      )),),
    );
  }
}