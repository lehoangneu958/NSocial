import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/services/Authentication.dart';
import 'package:nsocial/services/FirebaseOperations.dart';
import 'package:provider/provider.dart';

class PostFunctions with ChangeNotifier{
  TextEditingController commentController = TextEditingController();
  Future addLike(BuildContext context, String postId, String subDocId)async{

    return FirebaseFirestore.instance.collection('posts').doc(
      postId
    ).collection('likes').doc(subDocId).set({
      'likes': FieldValue.increment(1),
      'username': Provider.of<FirebaseOperations>(context, listen: false).getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false).getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false).getInitUserEmail,
      'time': Timestamp.now()
    });
  }


  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId)
    .collection('comments').doc(
      comment
    ).set({
      'comment': comment,
      'username': Provider.of<FirebaseOperations>(context, listen: false).getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false).getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false).getInitUserEmail,
      'time': Timestamp.now()
    });
  }


  showCommentsSheet(BuildContext context, DocumentSnapshot snapshot, String docId){
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context, builder: (context){
      return Padding(
        padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height*0.75,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4,
                      color: ConstantColors.whiteColor,
                    ),
                  ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: ConstantColors.whiteColor),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Center(
                  child: Text('Comments',
                  style: TextStyle(
                    color: ConstantColors.blueColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.55,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('posts').doc(docId)
                  .collection('comments').orderBy('time').snapshots(),
                  builder: (context, snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return new ListView(
                        children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot){
                          return Container(

                            height: MediaQuery.of(context).size.height*0.15,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8, left: 8),
                                      child: GestureDetector(
                                        child: CircleAvatar(
                                          backgroundColor: ConstantColors.darkColor,
                                          radius: 15,
                                          backgroundImage: NetworkImage(documentSnapshot['userimage']),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Text(documentSnapshot['username'],
                                              style: TextStyle(
                                                color: ConstantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14
                                              ),)
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.arrowUp,
                                          color: ConstantColors.blueColor,
                                          size: 14,)),
                                          Text('0', style: TextStyle(
                                            color: ConstantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14
                                          ),),
                                          IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.reply,
                                          color: ConstantColors.yellowColor,size: 14,)),
                                          
                                        ],
                                      ),
                                      
                                    )
                                  ],
                                  
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_outlined,
                                      color: ConstantColors.blueColor,
                                      size: 12,)),
                                      Container(
                                        width: MediaQuery.of(context).size.width*0.75,
                                        child: Text(
                                          documentSnapshot['comment'],
                                          style: TextStyle(
                                            color: ConstantColors.whiteColor,
                                            fontSize: 14
                                          ),
                                        ),
                                      ),
                                      IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.trashAlt,
                                          color: ConstantColors.redColor,size: 14,)),
                                    ],
                                  ),
                                ),
                                // Divider(
                                //   color: ConstantColors.darkColor.withOpacity(0.2),
                                // )
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.08,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      height: MediaQuery.of(context).size.height*0.1,
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Add Comment...',
                          hintStyle: TextStyle(
                            color: ConstantColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        controller: commentController,
                        style: TextStyle(
                            color: ConstantColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                      ),
                    ),
                    FloatingActionButton(onPressed: (){
                      print('Adding Comment...');
                      addComment(context, snapshot['caption'], commentController.text)
                      .whenComplete((){
                        commentController.clear();
                        notifyListeners();
                      });
                    },
                    child: Icon(FontAwesomeIcons.paperPlane,
                    color: ConstantColors.whiteColor,),)
                  ],
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            color: ConstantColors.blueGreyColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
          ),
        ),
      );
    } );
  }

  showLikes(BuildContext context, String postId){
    return showModalBottomSheet(context: context, builder: (context){
      return Container(
        child: Column(
          children: [
            Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4,
                      color: ConstantColors.whiteColor,
                    ),
                  ),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(color: ConstantColors.whiteColor),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Center(
                  child: Text('Likes',
                  style: TextStyle(
                    color: ConstantColors.blueColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),),
                ),
              ),
            Container(
              height: MediaQuery.of(context).size.height*0.2,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('posts').doc(
                  postId
                ).collection('likes').snapshots(),
                builder: (context, snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(),);
                  }
                  else {
                    return new ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot){
                        return ListTile(
                          leading: GestureDetector(
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(documentSnapshot['userimage']),

                            ),
                          ),
                          title: Text(documentSnapshot['username'], style: TextStyle(
                            color: ConstantColors.blueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          ),),
                          subtitle: Text(documentSnapshot['useremail'], style: TextStyle(
                            color: ConstantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                          ),),
                          trailing: Provider.of<Authentication>(context, listen: false)
                          .getUserUid == documentSnapshot['useruid'] ? 
                          Container(
                            width: 0,
                            height: 0,
                          ):
                          MaterialButton(
                            onPressed: (){},
                            child: Text('Follow', style: TextStyle(
                              color: ConstantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14
                            ),
                            ),
                            color: ConstantColors.blueColor,),

                        );
                      }).toList(),
                    );
                  }
                },
              ),
            )
          ],
        ),
        height: MediaQuery.of(context).size.height*0.5,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: ConstantColors.blueGreyColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12)
          )
        ),
      );
    });
  }

}