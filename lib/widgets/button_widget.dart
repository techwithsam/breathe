import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String btnName;
  final void Function() onPressed;
  const ButtonWidget({Key? key, required this.btnName, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      height: 50,
      child: MaterialButton(
        onPressed: onPressed,
        elevation: 0,
        child: Center(
          child: Text(
            btnName,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        color: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      ),
    );
  }
}
