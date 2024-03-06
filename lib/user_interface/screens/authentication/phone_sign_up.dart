import 'package:chat_app/controllers/signin_controller.dart';
import 'package:chat_app/user_interface/widgets/my_button.dart';
import 'package:chat_app/user_interface/widgets/my_snakbar.dart';
import 'package:chat_app/user_interface/widgets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneSignUp extends StatelessWidget {
  PhoneSignUp({super.key});

  final phoneController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final SignInController signInController = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Phone Authentication"),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Sign Up With Phone",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            MyTextField(
              prefixicon: Icon(Icons.phone),
              controller: phoneController,
              text: "Phone Number",
              keyboard: TextInputType.text,
            ),
            SizedBox(
              height: 20,
            ),
            MyButton(
              onPressed: () async {
                String phone = phoneController.text.trim();
                if (phone.isEmpty) {
                  SnackbarHelper.showSnackbar(
                      "Error", "Please enter a phone number");
                } else {
                  signInController.verifyPhoneNumber(phone);
                }
              },
              title: "Verify Number",
              width: 150,
            )
          ],
        ),
      ),
    );
  }
}
