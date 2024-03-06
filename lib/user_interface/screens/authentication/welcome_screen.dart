// ignore_for_file: prefer_const_constructors

import 'package:chat_app/controllers/google_sign_in_controller.dart';
import 'package:chat_app/user_interface/screens/authentication/sign_up_screen.dart';
import 'package:chat_app/user_interface/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_constants.dart';
import 'phone_sign_up.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late Size mq;

  @override
  Widget build(BuildContext context) {
    final GoogleSignInController googleSignInController =
        Get.put(GoogleSignInController());
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: MyAppBar(title: "Chat App"),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: Image.asset(
                "assets/icons/chat.png",
                width: mq.width * .5,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Material(
              child: Container(
                width: Get.width / 1.2,
                height: Get.height / 12,
                decoration: BoxDecoration(
                  color: AppConstant.appScendoryColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextButton.icon(
                  icon: Image.asset(
                    'assets/images/final-google-logo.png',
                    width: Get.width / 12,
                    height: Get.height / 12,
                  ),
                  label: Text(
                    "Sign in with google",
                    style: TextStyle(color: AppConstant.appTextColor),
                  ),
                  onPressed: () {
                    googleSignInController.signUpWithGoogle();
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Material(
              child: Container(
                width: Get.width / 1.2,
                height: Get.height / 12,
                decoration: BoxDecoration(
                  color: AppConstant.appScendoryColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextButton.icon(
                  icon: Icon(
                    CupertinoIcons.mail_solid,
                    color: Colors.white,
                    size: 35,
                  ),
                  label: Text(
                    "Sign Up with Email",
                    style: TextStyle(color: AppConstant.appTextColor),
                  ),
                  onPressed: () {
                    Get.to(() => SignUpScreen());
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Material(
              child: Container(
                width: Get.width / 1.2,
                height: Get.height / 12,
                decoration: BoxDecoration(
                  color: AppConstant.appScendoryColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextButton.icon(
                  icon: Icon(
                    CupertinoIcons.phone,
                    color: Colors.white,
                    size: 40,
                  ),
                  label: Text(
                    "Sign Up With Phone",
                    style: TextStyle(color: AppConstant.appTextColor),
                  ),
                  onPressed: () {
                    Get.to(() => PhoneSignUp());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
