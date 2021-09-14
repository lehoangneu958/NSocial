import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/screens/landingPage/landingServices.dart';
import 'package:nsocial/services/FirebaseOperations.dart';
import 'package:provider/provider.dart';

class LandingUtils with ChangeNotifier {
  final picker = ImagePicker();
  late File userAvatar;
  File get getUserAvatar => userAvatar;
  late String userAvatarUrl;
  String get getUserAvatarUrl => userAvatarUrl;

  Future pickUserAvatar(BuildContext context, ImageSource source) async {
    final pickedUserAvatar = await picker.getImage(source: source);
    pickedUserAvatar == null
        ? print("Select image")
        : userAvatar = File(pickedUserAvatar.path);
    print(userAvatar.path);

    userAvatar != null
        ? Provider.of<LandingServices>(context, listen: false)
            .showUserAvatar(context)
        : print('Image upload error');

    notifyListeners();
  }

  Future selectAvatarOptionsSheet(BuildContext context) async {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: ConstantColors.blueColor,
                    child: Text('Galery', style: TextStyle(color: ConstantColors.whiteColor,
                    fontWeight: FontWeight.bold, fontSize: 18),),
                    onPressed: (){
                      pickUserAvatar(context, ImageSource.gallery).whenComplete(() => {
                          Navigator.pop(context),
                          Provider.of<LandingServices>(context, listen: false).showUserAvatar(context)
                      });
                    }),
                    MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: ConstantColors.redColor,
                    child: Text('Camera', style: TextStyle(color: ConstantColors.whiteColor,
                    fontWeight: FontWeight.bold, fontSize: 18),),
                    onPressed: (){
                      pickUserAvatar(context, ImageSource.camera).whenComplete(() => {
                          Navigator.pop(context),
                          Provider.of<LandingServices>(context, listen: false).showUserAvatar(context)
                      });
                    })
                ],
              )
          ],
        ),
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: ConstantColors.blueGreyColor,
          borderRadius: BorderRadius.circular(12)
        ),
      );
    });
  }
}
