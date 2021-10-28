import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/screens/Messaging/GroupMessageHelper.dart';
import 'package:provider/provider.dart';

class NavigationDrawerMessageWidget extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  final String AdminUid;
  final String userUid;
  const NavigationDrawerMessageWidget(
      {Key? key,
      required this.AdminUid,
      required this.userUid,
      required this.documentSnapshot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: ConstantColors.blueGreyColor,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 40),
            AdminUid == userUid
                ? buildMenuItem(
                    text: 'Add Members',
                    icon: FontAwesomeIcons.plus,
                    onClicked: () => SelectedItem(context, 0))
                : Container(
                    width: 0,
                    height: 0,
                  ),
            buildMenuItem(
                text: 'Out Group',
                icon: EvaIcons.logInOutline,
                onClicked: () => SelectedItem(context, 1)),
            AdminUid == userUid
                ? buildMenuItem(
                    text: 'Delete Room',
                    icon: FontAwesomeIcons.trash,
                    onClicked: () => SelectedItem(context, 2))
                : Container(
                    width: 0,
                    height: 0,
                  ),
            AdminUid == userUid
                ? buildMenuItem(
                    text: 'Ceding the administrator',
                    icon: FontAwesomeIcons.userCog,
                    onClicked: () => SelectedItem(context, 3))
                : Container(
                    width: 0,
                    height: 0,
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = ConstantColors.whiteColor;
    return ListTile(
      leading: Icon(
        icon,
        color: color,
        size: 20,
      ),
      title: Text(text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          )),
      onTap: onClicked,
    );
  }

  void SelectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Provider.of<GroupMessageHelper>(context, listen: false)
            .addMembers(context, documentSnapshot['roomname']);
        break;
      case 1:
        AdminUid != userUid
            ? Provider.of<GroupMessageHelper>(context, listen: false)
                .leaveTheRoomChat(context, documentSnapshot['roomname'])
            : Provider.of<GroupMessageHelper>(context, listen: false)
                .showDialogAdminLeaveGroup(context);
        break;
      case 2:
        Provider.of<GroupMessageHelper>(context, listen: false)
            .deleteTheRoomChat(context, documentSnapshot['roomname']);
        break;
      case 3:
        Provider.of<GroupMessageHelper>(context, listen: false)
            .cedingAdmin(context, documentSnapshot['roomname']);
        break;
    }
  }
}
