

import 'package:flutter/material.dart';
import 'package:nsocial/common/Constantcolors.dart';

class FeedHelpers with ChangeNotifier{

  Widget feedBody(BuildContext context){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Container(
          height: MediaQuery.of(context).size.height*0.9,
          width: MediaQuery.of(context).size.width,
          decoration:  BoxDecoration(
            color: ConstantColors.redColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))
          ),
        ),
      ),
    );
  }

}