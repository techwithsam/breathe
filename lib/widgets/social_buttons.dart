import 'package:breathe/auth/firebase_service.dart';
import 'package:breathe/auth/register.dart';
import 'package:breathe/pages/settings.dart';
import 'package:breathe/widgets/bgimg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SocialButtons extends StatefulWidget {
  const SocialButtons({Key? key}) : super(key: key);

  @override
  State<SocialButtons> createState() => _SocialButtonsState();
}

class _SocialButtonsState extends State<SocialButtons> {
  FirebaseService service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(width: 30),
        GestureDetector(
          onTap: () => signInWithGoogle(),
          child: const CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/google.png'),
          ),
        ),
        GestureDetector(
          onTap: () => _loginwithFacebook(),
          child: const CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/facebook.png'),
          ),
        ),
        GestureDetector(
          onTap: () => snackBar('Coming soon', context),
          child: const CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/apple.jpg'),
          ),
        ),
        const SizedBox(width: 30),
      ],
    );
  }

  var loading = false;

  void _loginwithFacebook() async {
    _startLoading();

    try{
      final facebookloginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();
       User? result = FirebaseAuth.instance.currentUser;

     final facebookauthCredential = FacebookAuthProvider.credential(facebookloginResult.accessToken!.token);
     await FirebaseAuth.instance.signInWithCredential(facebookauthCredential);
     await FirebaseFirestore.instance.collection('user').add({
       'email' : userData['email'],
       'imageUrl' : userData['picture']['data']['url'],
       'name' : userData['name'],
     });

      Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsScreen(uid: result!.uid),
            ),
          );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        snackBar(
            'The email address is already in use by another account.', context);
      } else if (e.code == 'network-request-failed') {
        snackBar(noInternet, context);
      } else {
        snackBar('${e.message}', context);
      }
    }
    Navigator.of(context).pop();

  }

  void signInWithGoogle() async {
    _startLoading();
    try {
      await service.signInwithGoogle().then(
        (value) {
          User? result = FirebaseAuth.instance.currentUser;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsScreen(uid: result!.uid),
            ),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        snackBar(
            'The email address is already in use by another account.', context);
      } else if (e.code == 'network-request-failed') {
        snackBar(noInternet, context);
      } else {
        snackBar('${e.message}', context);
      }
    }
    Navigator.of(context).pop();
  }

  _startLoading() {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: SizedBox(
              width: 40, height: 40, child: CircularProgressIndicator()),
        );
      },
    );
  }
}
