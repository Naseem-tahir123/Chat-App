import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/user_interface/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInController extends GetxController {
  //instance of Google Sign in package
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // instance of FirebaseAuth package
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method Definition
  Future<void> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        EasyLoading.show(status: "Please Wait..");
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        final User? user = userCredential.user;

        if (user != null) {
          UserModel userModel = UserModel(
              uId: user.uid,
              username: user.displayName.toString(),
              email: user.email.toString(),
              phone: user.phoneNumber.toString(),
              userImg: user.photoURL.toString(),
              userDeviceToken: "",
              country: "",
              pushToken: "",
              isActive: "",
              isAdmin: false,
              isOnline: false,
              createdOn: DateTime.now(),
              city: "");

          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .set(userModel.toMap());
          EasyLoading.dismiss();

          Get.offAll(() => HomeScreen());
        }
      }
    } catch (e) {
      EasyLoading.dismiss();

      print(e);
    }
  }
}
