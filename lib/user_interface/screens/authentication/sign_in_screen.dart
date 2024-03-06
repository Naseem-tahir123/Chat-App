import 'package:chat_app/controllers/signin_controller.dart';
import 'package:chat_app/user_interface/widgets/custom_app_bar.dart';
import 'package:chat_app/user_interface/widgets/my_button.dart';
import 'package:chat_app/user_interface/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/my_snakbar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final SignInController signInController = Get.put(SignInController());
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: MyAppBar(title: "Sign In"),
        body: Stack(children: [
          Positioned(
              top: mq.height * .10,
              left: mq.width * .25,
              width: mq.width * .5,
              child: Image.asset("assets/icons/chat.png")),
          Positioned(
              bottom: mq.height * .30,
              left: mq.width * .05,
              width: mq.width * .90,
              child: MyTextField(
                  controller: email,
                  prefixicon: const Icon(Icons.email),
                  text: "Email")),
          Positioned(
            bottom: mq.height * .18,
            left: mq.width * .05,
            width: mq.width * .90,
            child: Obx(
              () => MyTextField(
                text: "Password",
                controller: password,
                prefixicon: const Icon(Icons.password),
                lines: 1,
                obscureText: signInController.isPasswordVisible.value,
                suffixicon: GestureDetector(
                    onTap: () {
                      signInController.isPasswordVisible.toggle();
                    },
                    child: signInController.isPasswordVisible.value
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility)),
              ),
            ),
          ),
          Positioned(
              bottom: mq.height * .05,
              left: mq.width * .25,
              width: mq.width * .5,
              child: GetBuilder<SignInController>(
                builder: (signInController) {
                  return signInController.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : MyButton(
                          title: "Sign in",
                          width: 100,
                          onPressed: () async {
                            String mail = email.text.trim();
                            String passwrd = password.text.trim();
                            if (mail.isEmpty || passwrd.isEmpty) {
                              SnackbarHelper.showSnackbar(
                                  "Error", "Please enter all details");
                            } else {
                              await signInController.signInWithEmail(
                                  mail, passwrd);
                            }
                          },
                        );
                },
              ))
        ]),
      ),
    );
  }
}
