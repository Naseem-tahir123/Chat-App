import 'package:chat_app/controllers/signup_controller.dart';
import 'package:chat_app/user_interface/screens/authentication/sign_in_screen.dart';
import 'package:chat_app/user_interface/widgets/custom_app_bar.dart';
import 'package:chat_app/user_interface/widgets/my_button.dart';
import 'package:chat_app/user_interface/widgets/my_snakbar.dart';
import 'package:chat_app/user_interface/widgets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController signUpController = Get.put(SignUpController());
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Sign Up"),
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          const Text(
            "Sign Up With Email",
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          MyTextField(
            controller: username,
            keyboard: TextInputType.name,
            text: "user name",
            inputAction: TextInputAction.done,
            prefixicon: const Icon(Icons.person),
          ),
          MyTextField(
            controller: email,
            keyboard: TextInputType.name,
            text: "Email",
            inputAction: TextInputAction.done,
            prefixicon: const Icon(Icons.email),
          ),
          Obx(
            () => MyTextField(
              controller: password,
              keyboard: TextInputType.number,
              obscureText: signUpController.isPasswordVisible.value,
              lines: 1,
              text: "Password",
              prefixicon: const Icon(Icons.password),
              suffixicon: GestureDetector(
                  onTap: () {
                    signUpController.isPasswordVisible.toggle();
                  },
                  child: signUpController.isPasswordVisible.value
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          MyButton(
            onPressed: () async {
              String name = username.text.trim();
              String mail = email.text.trim();
              String Password = password.text.trim();
              String deviceToken = "";
              if (name.isEmpty || mail.isEmpty || Password.isEmpty) {
                SnackbarHelper.showSnackbar(
                  "Error",
                  "Please enter all details ",
                );
              } else {
                UserCredential? userCredential =
                    await signUpController.SignUpWithEmail(
                        name, mail, Password, deviceToken);
                if (userCredential != null) {
                  SnackbarHelper.showSnackbar(
                    "Verification Email Sent",
                    "Check your email",
                  );
                  FirebaseAuth.instance.signOut();
                  Get.to(() => const SignInScreen());
                }
              }
            },
            title: "Sign Up",
            width: 100,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text("Already have an account"),
          const SizedBox(
            width: 2,
          ),
          InkWell(
              onTap: () {
                Get.to(() => const SignInScreen());
              },
              child: const Text(
                "Sign up",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }
}
