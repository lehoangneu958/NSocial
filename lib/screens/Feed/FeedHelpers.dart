import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/services/Authentication.dart';
import 'package:provider/provider.dart';

class FeedHelpers with ChangeNotifier {
  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SizedBox(
                    height: 500,
                    width: MediaQuery.of(context).size.width,
                    child: Lottie.asset('assets/animations/loading.json'),
                  ),
                );
              } else {
               return  new ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
        return Padding(
          padding: const EdgeInsets.only(bottom:8.0),
          child: Container(
            decoration: BoxDecoration(
              color: ConstantColors.blueColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15)
            ),
           height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: CircleAvatar(
                          backgroundColor: ConstantColors.transperant,
                          radius: 30,
                          backgroundImage:
                              NetworkImage(documentSnapshot['userimage']),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             
                              Container(
                                  child: RichText(
                                      text: TextSpan(
                                          text: documentSnapshot['username'],
                                          style: TextStyle(
                                              color: ConstantColors.blueColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                          ))),
                              RichText(text: TextSpan(
                                        text: ' , 12 hours ago',
                                        style: TextStyle(
                                            color: ConstantColors.lightColor
                                                .withOpacity(0.8))))
                                  
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Container(
                                child: Text(
                                  documentSnapshot['caption'],
                                  style: TextStyle(
                                      color: ConstantColors.greenColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                 ),
                Container(
                  color: ConstantColors.redColor,
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(
                    child: Image.network(documentSnapshot['postimage'], scale: 2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      //---------heart
                      Container(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              child: Icon(
                                FontAwesomeIcons.heart,
                                color: ConstantColors.redColor,
                                size: 22,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: 8)),
                            Text(
                              '0',
                              style: TextStyle(
                                  color: ConstantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      //------comment
                      Container(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              child: Icon(
                                FontAwesomeIcons.comment,
                                color: ConstantColors.blueColor,
                                size: 22,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: 8)),
                            Text(
                              '0',
                              style: TextStyle(
                                  color: ConstantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      //--------award
                      Container(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              child: Icon(
                                FontAwesomeIcons.award,
                                color: ConstantColors.yellowColor,
                                size: 22,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: 8)),
                            Text(
                              '0',
                              style: TextStyle(
                                  color: ConstantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                  Provider.of<Authentication>(context, listen: false).getUserUid ==
                          documentSnapshot['useruid']
                      ? IconButton(
                          onPressed: () {},
                          icon: Icon(
                            EvaIcons.moreVertical,
                            color: ConstantColors.whiteColor,
                          ))
                      : Container(
                          width: 0.0,
                          height: 0.0,
                        )
                    ],
                  ),
                ),
                
              ],
            ),
          ),
        );
      }).toList(),
    );
              }
              
            },
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: ConstantColors.darkColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        ),
      ),
    );
  }

  
}
