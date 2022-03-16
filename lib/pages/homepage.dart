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
      player.load('audio.mp3');
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
            onPressed: () => player.clear(Uri.parse('audio.mp3')),
            icon: const Icon(Icons.pause),
          ),
          IconButton(
            onPressed: () => player.play('audio.mp3'),
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
