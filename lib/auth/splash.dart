import 'package:breathe/auth/onboarding.dart';
import 'package:breathe/pages/homepage.dart';
import 'package:breathe/widgets/bgimg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? result = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              result != null ? const HomePage() : const OnboardingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        backgroundImage('spl.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Center(child: CircularProgressIndicator()),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
