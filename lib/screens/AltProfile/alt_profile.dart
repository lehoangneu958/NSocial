import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/screens/AltProfile/alt_profile_helper.dart';
import 'package:nsocial/screens/HomePage/HomePage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AltProfile extends StatelessWidget {

  final String userUid;
  const AltProfile({required this.userUid, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
      AppBar(
      leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded,
      color: ConstantColors.whiteColor,),
      onPressed: (){
        // Navigator.pushReplacement(context, PageTransition(child: HomePage(),
        // type: PageTransitionType.bottomToTop));
        Navigator.pop(context);
      },),
      backgroundColor: ConstantColors.blueGreyColor.withOpacity(0.4),
      actions: [
        IconButton(icon: Icon(EvaIcons.moreVertical,
      color: ConstantColors.whiteColor,),
      onPressed: (){
        Navigator.pushReplacement(context, PageTransition(child: HomePage(),
        type: PageTransitionType.bottomToTop));
      },),
      ],
      centerTitle: true,
      title: RichText(text: TextSpan(
        text: 'N',
        style: TextStyle(
          color: ConstantColors.whiteColor,
          fontWeight: FontWeight.bold,
          fontSize: 20
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'Social',
            style: TextStyle(
              color: ConstantColors.blueColor,
              fontWeight: FontWeight.bold,
              fontSize: 20
            )
          )
        ]
      )),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Container(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(
              userUid
            ).snapshots(),
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              else{
                return Column(
                  children: [
                    Provider.of<AltprofileHelper>(context, listen: false)
                    .headerProfile(context, snapshot.data!, userUid),
                    Provider.of<AltprofileHelper>(context, listen: false)
                    .middleProfile(context, snapshot.data!),
                    Provider.of<AltprofileHelper>(context, listen: false)
                    .footerProfile(context, snapshot.data!),
                  ],
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,

                );
              }
            },
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            color: ConstantColors.blueGreyColor.withOpacity(0.6)
          ),
        ),
      ),
    ),
      
    );
  }
}