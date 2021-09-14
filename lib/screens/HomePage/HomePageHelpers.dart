import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:nsocial/common/Constantcolors.dart';

class HomePageHelpers with ChangeNotifier{

  Widget bottomNavibar(int index, PageController pageController){
    return CustomNavigationBar(
      currentIndex: index,
      bubbleCurve: Curves.bounceIn,
      scaleCurve: Curves.decelerate,
      selectedColor: ConstantColors.blueColor,
      unSelectedColor: ConstantColors.whiteColor,
      strokeColor: ConstantColors.blueColor,
      scaleFactor: 0.5,
      iconSize: 30,
      onTap: (val) {
        index = val;
        pageController.jumpToPage(val);
        notifyListeners();
      },
      backgroundColor: Color(0xff040307),
      items: [
        CustomNavigationBarItem(icon: Icon(EvaIcons.home)),
        CustomNavigationBarItem(icon: Icon(Icons.message_rounded)),
        CustomNavigationBarItem(icon: Icon(Icons.account_circle_rounded))

        
      ],
    );
  }

}