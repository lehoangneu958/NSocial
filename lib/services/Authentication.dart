import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nsocial/screens/HomePage/HomePage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Authentication with ChangeNotifier {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  late String userUid;
  String get getUserUid => userUid;

  Future logIntoAccount(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      userUid = user!.uid;
      Navigator.pushReplacement(
          context,
          PageTransition(
              child: HomePage(), type: PageTransitionType.bottomToTop));
    } on PlatformException catch (error) {
      print(error.message.toString());
      Fluttertoast.showToast(
          msg: error.message.toString(), gravity: ToastGravity.TOP);
    }

    print("DDDDD: $userUid");
    notifyListeners();
  }

  Future createAccount(String email, String password) async {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    User? user = userCredential.user;
    userUid = user!.uid;
    print('Created account Uid => $userUid');
    notifyListeners();
  }

  Future logOutviaEmail() {
    return firebaseAuth.signOut();
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(authCredential);
    final User? user = userCredential.user;
    assert(user!.uid != null);
    userUid = user!.uid;
    print('Google User Uid => $userUid');
    notifyListeners();
  }

  Future signOutWithGoogle() async {
    return googleSignIn.signOut();
  }
}
