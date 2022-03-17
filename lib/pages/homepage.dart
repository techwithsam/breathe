import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:breathe/pages/settings.dart';
import 'package:breathe/widgets/bgimg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String uid;
  const HomePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  User? result = FirebaseAuth.instance.currentUser;
  AudioPlayer audioPlayer = AudioPlayer();
  String audioUrl =
      "https://firebasestorage.googleapis.com/v0/b/breathe-76f24.appspot.com/o/audio.mp3?alt=media&token=9d9e185d-8bad-41f2-90a8-b11dbb4d1c13";
  Timer? timer;
  bool pause = false, isPlaying = true;
  final dbRef = FirebaseDatabase.instance.ref().child("Users");
  late final AnimationController animationController = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat();

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        const Duration(seconds: 5), (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String getImages() {
      List imgs = ['spl.jpg', 'splash.jpg'].toList();

      var randomItem = (imgs.toList()..shuffle()).first;

      return '$randomItem';
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Dashboard'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              setState(() {
                isPlaying = !isPlaying;
              });
              await audioPlayer.setUrl(audioUrl);
              isPlaying
                  ? await audioPlayer.play(audioUrl)
                  : await audioPlayer.pause();
            },
            icon: Icon(isPlaying ? Icons.play_arrow : Icons.pause),
            label: Text(isPlaying ? 'Starting playing' : 'Stop playing'),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF000000)),
              accountName: const Text(
                'Hello There,',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              accountEmail: Text('${result!.displayName}'),
            ),
            ListTile(
              leading: Icon(Icons.settings,
                  color: Colors.black.withOpacity(0.7), size: 30),
              title: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SettingsScreen(uid: widget.uid),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.help,
                  color: Colors.black.withOpacity(0.7), size: 30),
              title: Text(
                'Help',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: AnimatedBuilder(
          animation: animationController,
          child: Stack(
            children: [
              backgroundImage(getImages()),
            ],
          ),
          builder: (context, _widget) {
            return Transform.scale(
              scale: animationController.value * 1,
              child: _widget,
            );
            // return Transform.rotate(
            //   angle: animationController.value * 20,
            //   child: _widget,
            // );
          },
        ),
      ),
    );
  }
}
