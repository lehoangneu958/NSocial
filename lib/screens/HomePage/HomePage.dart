import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/screens/Chatroom/Chatroom.dart';
import 'package:nsocial/screens/Feed/Feed.dart';
import 'package:nsocial/screens/HomePage/HomePageHelpers.dart';
import 'package:nsocial/screens/Profile/Profile.dart';
import 'package:nsocial/services/FirebaseOperations.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController homepageController = PageController();
  int pageIndex = 0;
  @override
  void initState() {
    Provider.of<FirebaseOperations>(context, listen: false).initUserData(context);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ConstantColors.darkColor,
        body: PageView(
          controller: homepageController,
          children: [Feed(), Chatroom(), Profile()],
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (page) {
            setState(() {
              pageIndex = page;
            });
          },
        ),
        bottomNavigationBar:
            Provider.of<HomePageHelpers>(context, listen: false)
                .bottomNavibar(pageIndex, homepageController));
  }
}
