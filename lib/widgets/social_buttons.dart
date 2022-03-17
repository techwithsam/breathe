import 'package:breathe/auth/firebase_service.dart';
import 'package:breathe/auth/register.dart';
import 'package:breathe/pages/settings.dart';
import 'package:breathe/widgets/bgimg.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

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
          onTap: () => singInWithFacebook(),
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

  signInWithGoogle() async {
    _startLoading();
    try {
      debugPrint('Starting point...');
      // await service.signInWithGoogle().then((value) {
      //   debugPrint('Second point $value');
      //   User? result = FirebaseAuth.instance.currentUser;
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => SettingsScreen(uid: result!.uid),
      //     ),
      //   );
      // });

      //.-------------------
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
      // 'signInWithGoogle succeeded: $user';
      return await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) {
        debugPrint('Second point $value');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SettingsScreen(uid: user.uid),
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
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

  singInWithFacebook() async {
    _startLoading();
    try {
      // await service.signInWithFacebook().then((value) {
      //   debugPrint('Value - $value');
      //   User? result = FirebaseAuth.instance.currentUser;
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => SettingsScreen(uid: result!.uid),
      //     ),
      //   );
      // });
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: [
          'public_profile',
          'email',
          'pages_show_list',
          'pages_messaging',
          'pages_manage_metadata'
        ],
      );
      if (result.status == LoginStatus.success) {
        // you are logged
        // final AccessToken accessToken = result.accessToken!;
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SettingsScreen(uid: user.uid),
          ),
        );
      } else {
        debugPrint("${result.status}");
        debugPrint(result.message);
      }
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

  void singInWithApple() async {}

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
