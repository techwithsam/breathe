import 'package:flutter/material.dart';

Widget backgroundImage(String img) {
  return ShaderMask(
    shaderCallback: (bounds) => const LinearGradient(
      colors: [Colors.black, Colors.black12],
      begin: Alignment.bottomCenter,
      end: Alignment.center,
    ).createShader(bounds),
    blendMode: BlendMode.darken,
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/$img'),
          fit: BoxFit.cover,
          colorFilter: const ColorFilter.mode(Colors.black45, BlendMode.darken),
        ),
      ),
    ),
  );
}

snackBar(String msg, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    action: SnackBarAction(label: 'Close', onPressed: () {}),
  ));
}
