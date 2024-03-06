import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String title;
  final double? width;
  final Function()? onPressed;
  const MyButton({super.key, required this.title, this.onPressed, this.width});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Container(
        height: 40,
        width: width,
        decoration: BoxDecoration(
          color: const Color(0xff764abc),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
          ),
        )),
      ),
    );
  }
}
