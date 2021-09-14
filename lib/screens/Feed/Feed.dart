import 'package:flutter/material.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/screens/Feed/FeedHelpers.dart';
import 'package:nsocial/utils/uploadPost.dart';
import 'package:provider/provider.dart';

class Feed extends StatelessWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        backgroundColor: ConstantColors.darkColor.withOpacity(0.4),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<UploadPost>(context, listen: false).selectPostImageType(context);
              },
              icon: Icon(
                Icons.camera_enhance_rounded,
                color: ConstantColors.greenColor,
              ))
        ],
        title: RichText(
          text: TextSpan(
              text: 'N',
              style: TextStyle(
                  color: ConstantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              children: <TextSpan>[
                TextSpan(
                  text: 'Social',
                  style: TextStyle(
                      color: ConstantColors.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                )
              ]),
        ),
      ),
      body: Provider.of<FeedHelpers>(context, listen: false).feedBody(context),
    );
  }
}
