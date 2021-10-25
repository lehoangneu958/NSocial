

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/screens/Chatroom/ChatroomHelper.dart';
import 'package:provider/provider.dart';

class Chatroom extends StatelessWidget {
  const Chatroom({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: FloatingActionButton(onPressed: (){
        Provider.of<ChatroomHelper>(context, listen: false).showCreateChatroomSheet(context);
      },
      backgroundColor: ConstantColors.blueGreyColor,
      child: Icon(FontAwesomeIcons.plus, color: ConstantColors.greenColor,),
      ),

      appBar: AppBar(
        backgroundColor: ConstantColors.blueGreyColor.withOpacity(0.4),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(EvaIcons.moreVertical, color: ConstantColors.whiteColor,))
        ],
        title: RichText(
          text: TextSpan(
              text: 'Chat ',
              style: TextStyle(
                  color: ConstantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              children: <TextSpan>[
                TextSpan(
                  text: 'Box',
                  style: TextStyle(
                      color: ConstantColors.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                )
              ]),
        ),
        leading: IconButton(
          onPressed: (){
            Provider.of<ChatroomHelper>(context, listen: false).showCreateChatroomSheet(context);
          },
          icon: Icon(FontAwesomeIcons.plus, color: ConstantColors.greenColor,),
        ),
      ),
    body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Provider.of<ChatroomHelper>(context, listen: false).showChatrooms(context),
    ),
    );
  }
}