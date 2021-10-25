import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/screens/Messaging/GroupMessageHelper.dart';
import 'package:nsocial/screens/Messaging/NavigationDrawer.dart';
import 'package:nsocial/services/Authentication.dart';
import 'package:provider/provider.dart';

class GroupMessage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  GroupMessage({ Key? key, required this.documentSnapshot }) : super(key: key);

  @override
  _GroupMessageState createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessage> {
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    // Provider.of<GroupMessageHelper>(context, listen: false)
    // .checkIfJoined(
    //   context
    //   , widget.documentSnapshot.id
    //   , widget.documentSnapshot['useruid']);

    //   if (Provider.of<GroupMessageHelper>(context, listen: false).getHasMemberJoined
    //   == false){
    //     Timer(Duration(milliseconds: 10),(){
    //       Provider.of<GroupMessageHelper>(context, listen: false)
    //       .askToJoin(context, widget.documentSnapshot.id);
    //     });
    //   }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer:
       NavigationDrawerMessageWidget(userUid:
        Provider.of<Authentication>(context, listen: false).getUserUid
        ,AdminUid: widget.documentSnapshot['useruid'], documentSnapshot: widget.documentSnapshot,),
     
      appBar: AppBar(
        
        
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new_rounded, color: ConstantColors.whiteColor,)
        , onPressed: () { Navigator.pop(context);  },),
        
        backgroundColor: ConstantColors.blueGreyColor,
        title: Container(
          color: ConstantColors.transperant,
          width: MediaQuery.of(context).size.width*0.5,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.documentSnapshot['roomavatar']),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.documentSnapshot['roomname'], style: TextStyle(
                      color: ConstantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14
                    ),),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('chatrooms')
                      .doc(widget.documentSnapshot.id)
                      .collection('members').snapshots(),
                      builder: (context, snapshot){
                        if (snapshot.connectionState == ConnectionState.waiting){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        else{
                          return new Text('${snapshot.data!.docs.length.toString()} members', style: TextStyle(
                            color: ConstantColors.greenColor.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                          ),);
                        }
                      },
                    )
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
                color: ConstantColors.darkColor,
                child: Provider.of<GroupMessageHelper>(context, listen: false)
                .showMessages(context, widget.documentSnapshot, widget.documentSnapshot['useruid']),
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
                        onTap: (){
                          Provider.of<GroupMessageHelper>(context, listen: false)
                          .showSticker(context, widget.documentSnapshot.id);
                        },
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
                          .sendMessage(context, widget.documentSnapshot, messageController);
                          
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