import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // for password visibility
  var isPasswordVisible = false.obs;

  Future<UserCredential?> SignUpWithEmail(
    String username,
    String userEmail,
    String userPassword,
    String userDeviceToken,
  ) async {
    try {
      EasyLoading.show(status: "Please Wait...");
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      //sent email verification
      await userCredential.user!.sendEmailVerification();

      UserModel userModel = UserModel(
          uId: userCredential.user!.uid,
          username: username,
          email: userEmail,
          phone: "",
          userImg: "",
          userDeviceToken: userDeviceToken,
          country: "",
          pushToken: "",
          isActive: "",
          isAdmin: false,
          isOnline: false,
          createdOn: DateTime.now(),
          city: "");

      //add data to firestore
      _firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());
      EasyLoading.dismiss();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Error", "$e", snackPosition: SnackPosition.BOTTOM);
    }
    return null;
  }
}
