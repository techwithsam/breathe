import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

DatabaseReference db = FirebaseDatabase.instance.ref().child("Users");

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future signInWithGoogle() async {
    try {
      debugPrint("signInWithGoogle");
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      debugPrint("Check 1...");
      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;
      debugPrint("Check 2...");
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication!.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      debugPrint("Check 3...");
      debugPrint("Something happen here");

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      saveToDatabase(
        dob: '',
        email: user!.email,
        name: user.displayName,
        phn: user.phoneNumber,
        uid: user.uid,
      );
      'signInWithGoogle succeeded: $user';
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      return e.message;
    }
  }

  Future<String?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      switch (result.status) {
        case LoginStatus.success:
          final AuthCredential facebookCredential =
              FacebookAuthProvider.credential(result.accessToken!.token);
          final userCredential =
              await _auth.signInWithCredential(facebookCredential);
          final User? user = userCredential.user;
          saveToDatabase(
            dob: '',
            email: user!.email,
            name: user.displayName,
            phn: user.phoneNumber,
            uid: user.uid,
          );
          return 'signInWithFacebook succeeded: $userCredential';
        case LoginStatus.cancelled:
          return 'Facebook authentication cancelled!';
        case LoginStatus.failed:
          return 'Facebook authentication failed! ${result.message}'; 
        default:
          return null;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      return e.message;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
    await _auth.signOut();
  }
}

void saveToDatabase({uid, email, name, phn, dob}) {
  db.child(uid).set({
    "uid": uid,
    "email": email,
    "name": name,
    "phn": phn,
    "dob": dob,
  }).then((value) {
    debugPrint('Information saved to database');
  });
}
