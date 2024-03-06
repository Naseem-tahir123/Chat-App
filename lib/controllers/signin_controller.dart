// // ignore_for_file: file_names, unused_field, body_might_complete_normally_nullable, unused_local_variable

import 'package:chat_app/user_interface/screens/authentication/otp_screen.dart';
import 'package:chat_app/user_interface/screens/home_screen.dart';
import 'package:chat_app/user_interface/widgets/my_snakbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  //for password visibilty
  var isPasswordVisible = false.obs;

  Future<UserCredential?> signInWithEmail(
      String userEmail, String userPassword) async {
    isLoading = true;
    // update();
    try {
      // EasyLoading.show(status: "Please wait");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      // EasyLoading.dismiss();
      if (userCredential.user!.emailVerified) {
        Get.offAll(() => HomeScreen());
        Get.snackbar(
          " Success",
          " Login successfully ",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          "Please Verify your Email before log in",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      // EasyLoading.dismiss();
      Get.snackbar(
        "Error",
        "$e",
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } finally {
      isLoading = false;
      // update();
    }
    return null;
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    try {
      EasyLoading.show(status: "please wait...");
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (_) {},
          verificationFailed: (e) {
            EasyLoading.dismiss();
            SnackbarHelper.showSnackbar("Error", "$e");
          },
          codeSent: (String verificationId, int? token) {
            EasyLoading.dismiss();
            Get.to(() => OtpScreen(verificationId: verificationId));
          },
          codeAutoRetrievalTimeout: (e) {
            EasyLoading.dismiss();
            SnackbarHelper.showSnackbar("Error", "$e");
          });
    } catch (e) {
      EasyLoading.dismiss();
      SnackbarHelper.showSnackbar("Error", "$e");
    }
  }
}
