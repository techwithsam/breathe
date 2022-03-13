import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:breathe/pages/settings.dart';
import 'package:breathe/widgets/bgimg.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String? uid;
  const HomePage({Key? key, this.uid}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final player = AudioCache();
  Timer? timer;
  late final AnimationController animationController = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat();

  @override
  void initState() {
    super.initState();
    player.loop(
      "audio.mp3",
      isNotification: true,
      stayAwake: true,
      volume: 0.1,
    );
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
                    builder: (_) => const SettingsScreen(),
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
