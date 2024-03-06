// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app/user_interface/screens/authentication/welcome_screen.dart';
import 'package:chat_app/user_interface/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3), () {
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(statusBarColor: Colors.black26));

      signedIn(context);
    });
  }

  Future<void> signedIn(BuildContext context) async {
    if (user != null) {
      Get.offAll(() => HomeScreen());
    } else {
      Get.offAll(() => WelcomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/app_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: DefaultTextStyle(
                  style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                  child: AnimatedTextKit(
                      pause: Duration(microseconds: 100),
                      animatedTexts: [
                        TypewriterAnimatedText("Chat App"),
                      ])),
            )
          ],
        ),
      ),
    );
  }
}
