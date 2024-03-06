import 'package:chat_app/Api/apis.dart';
import 'package:chat_app/user_interface/screens/home_screen.dart';
import 'package:chat_app/user_interface/widgets/my_snakbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class OtpController extends GetxController {
  Future<void> verifyOtp(String otp, String verificationId) async {
    try {
      EasyLoading.show(status: 'Verifying...');
      final credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      await ApIs.auth.signInWithCredential(credential);

      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        UserModel userModel = UserModel(
          uId: user.uid,
          username: user.displayName ?? "Your Name",
          email: user.email ?? "example@gmail.com",
          phone: user.phoneNumber ?? "",
          userImg: user.photoURL ??
              "https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHVzZXIlMjBwcm9maWxlfGVufDB8fDB8fHww",
          userDeviceToken: "",
          country: "",
          pushToken: "",
          isActive: "",
          isAdmin: false,
          isOnline: false,
          createdOn: DateTime.now(),
          city: "",
        );

        // Store the user data in Firestore
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .set(userModel.toMap());
      }
      EasyLoading.dismiss();
      Get.offAll(() => HomeScreen());
    } catch (e) {
      EasyLoading.dismiss();
      SnackbarHelper.showSnackbar("Error", "$e");
    }
  }
}
