import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/screens/Messaging/GroupMessageHelper.dart';
import 'package:nsocial/services/Authentication.dart';
import 'package:provider/provider.dart';

class GroupMessage extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  GroupMessage({ Key? key, required this.documentSnapshot }) : super(key: key);
  final TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        actions: [
         
          Provider.of<Authentication>(context, listen: false).getUserUid == documentSnapshot['useruid']
          ? IconButton(onPressed: (){}, icon: Icon(EvaIcons.moreVertical, color: ConstantColors.whiteColor,))
          : Container(
            width: 0,
            height: 0,
          ),
           IconButton(onPressed: (){}
          , icon: Icon(EvaIcons.logInOutline, color: ConstantColors.redColor,)),
        ],
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new_rounded, color: ConstantColors.whiteColor,)
        , onPressed: () { Navigator.pop(context);  },),
        
        backgroundColor: ConstantColors.blueGreyColor,
        title: Container(
          color: ConstantColors.transperant,
          width: MediaQuery.of(context).size.width*0.5,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(documentSnapshot['roomavatar']),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(documentSnapshot['roomname'], style: TextStyle(
                      color: ConstantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14
                    ),),
                    Text('2 members', style: TextStyle(
                      color: ConstantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10
                    ),)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              AnimatedContainer(
                
                height: MediaQuery.of(context).size.height*0.8,
                width: MediaQuery.of(context).size.width,
                duration: Duration(seconds: 1),
              curve: Curves.bounceIn,
              ),
              Padding(
                padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  color: ConstantColors.blueGreyColor,
                  child: Row(
                    children: [
                      GestureDetector(
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: ConstantColors.transperant,
                          backgroundImage: AssetImage('assets/icons/sunflower.png'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.7,
                          child: TextField(
                            controller: messageController,
                            style: TextStyle(
                              color: ConstantColors.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),
                            decoration: InputDecoration(
                              hintText: 'Drop a hi...',
                              hintStyle: TextStyle(
                              color: ConstantColors.greenColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            )
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton(onPressed: (){
                        if (messageController.text.isNotEmpty){
                          Provider.of<GroupMessageHelper>(context, listen: false)
                          .sendMessage(context, documentSnapshot, messageController);
                        }
                      },
                      backgroundColor: ConstantColors.blueColor,
                      child: Icon(Icons.send_sharp, color: ConstantColors.whiteColor,),)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}