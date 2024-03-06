// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor = Color(0xff764abc).withOpacity(0.9);
  final Color textColor = Colors.white;
  MyAppBar({
    super.key,
    required this.title,
  });
  @override
  Size get preferredSize => Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      actions: const [],
      centerTitle: true,
      backgroundColor: backgroundColor,
    );
  }
}
