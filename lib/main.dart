import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/screens/HomePage/HomePageHelpers.dart';
import 'package:nsocial/screens/Profile/ProfileHelpers.dart';
import 'package:nsocial/screens/landingPage/landingHelpers.dart';
import 'package:nsocial/screens/landingPage/landingServices.dart';
import 'package:nsocial/screens/landingPage/landingUtils.dart';
import 'package:nsocial/screens/splashscreen/splashscreen.dart';
import 'package:nsocial/services/Authentication.dart';
import 'package:nsocial/services/FirebaseOperations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => LandingHelpers(),),
      ChangeNotifierProvider(create: (_) => Authentication(),),
      ChangeNotifierProvider(create: (_) => LandingServices(),),
      ChangeNotifierProvider(create: (_) => FirebaseOperations(),),
      ChangeNotifierProvider(create: (_) => LandingUtils(),),
      ChangeNotifierProvider(create: (_) => HomePageHelpers(),),
      ChangeNotifierProvider(create: (_) => ProfileHelpers(),),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        accentColor:  ConstantColors.blueColor,
        fontFamily: 'Poppins',
        canvasColor: Colors.transparent
      ),
      home: SplashScreen()
    ),);
  }
}

