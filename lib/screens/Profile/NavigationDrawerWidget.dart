import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nsocial/common/Constantcolors.dart';
import 'package:nsocial/screens/Profile/Information.dart';
import 'package:nsocial/screens/Profile/ProfileHelpers.dart';
import 'package:nsocial/screens/landingPage/landingPage.dart';
import 'package:nsocial/services/Authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: ConstantColors.blueGreyColor,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 40),
            buildMenuItem(
                text: 'Update Information',
                icon: FontAwesomeIcons.addressCard,
                onClicked: () => SelectedItem(context, 1)),
            buildMenuItem(
                text: 'Log out',
                icon: FontAwesomeIcons.signOutAlt,
                onClicked: () => SelectedItem(context, 0))
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
        Provider.of<ProfileHelpers>(context, listen: false)
            .logOutDialog(context);
        break;
      case 1:
        Navigator.push(
            context,
            PageTransition(
                child: Information(), type: PageTransitionType.leftToRight));
        break;
    }
  }
}
