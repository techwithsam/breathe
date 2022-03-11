import 'package:breathe/pages/settings.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: const [
            Text('Hello, John Doe'),
          ],
        ),
      ),
    );
  }
}
