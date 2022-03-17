import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:breathe/pages/settings.dart';
import 'package:breathe/widgets/bgimg.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String uid;
  const HomePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final player = AudioCache();
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  String audioUrl =
      "https://firebasestorage.googleapis.com/v0/b/breathe-76f24.appspot.com/o/audio.mp3?alt=media&token=9d9e185d-8bad-41f2-90a8-b11dbb4d1c13";
  Timer? timer;
  bool pause = false;
  final dbRef = FirebaseDatabase.instance.ref().child("Users");
  late final AnimationController animationController = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat();

  @override
  void initState() {
    super.initState();
    audioPlayer.setUrl(audioUrl);
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
        centerTitle: true,
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () async {
              // int result = await audioPlayer.pause();
              // debugPrint('$result');
              await audioPlayer.stop();
              await audioPlayer.notificationService.clearNotification();
            },
            icon: const Icon(Icons.pause),
          ),
          IconButton(
            onPressed: () async {
              // player.play('audio.mp3');
              // int result = await audioPlayer.play(audioUrl);
              // debugPrint('$result');
              await audioPlayer.notificationService.startHeadlessService();
              await audioPlayer.notificationService.setNotification(
                title: 'My Song',
                albumTitle: 'My Album',
                artist: 'My Artist',
                imageUrl: 'Image URL or blank',
                forwardSkipInterval: const Duration(seconds: 30),
                backwardSkipInterval: const Duration(seconds: 30),
                duration: const Duration(minutes: 3),
                elapsedTime: const Duration(seconds: 15),
                enableNextTrackButton: true,
                enablePreviousTrackButton: true,
              );

              await audioPlayer.play(
                audioUrl,
                isLocal: false,
              );
            },
            icon: const Icon(Icons.play_arrow),
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF000000)),
              accountName: Text(
                'Hello There,',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              accountEmail: Text(''),
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
