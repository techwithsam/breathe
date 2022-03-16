import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  DatabaseReference db = FirebaseDatabase.instance.ref().child("Users");

  Future<String?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      debugPrint('Information saved to database - asa');

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;
      debugPrint('Information saved to database - kdsk');

      db.child(user!.uid).set({
        "uid": user.uid,
        "email": user.email,
        "name": user.displayName,
        "phn": user.phoneNumber,
        "dob": '',
      }).then((value) {
        debugPrint('Information saved to database');
      });
      debugPrint('Information saved  csnsto database');
      return 'signInWithGoogle succeeded: $user';
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      debugPrint('Information saved to database - dsk');
      return e.message;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
