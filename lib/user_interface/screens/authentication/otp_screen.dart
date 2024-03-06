import 'package:chat_app/controllers/otp_controller.dart';
import 'package:chat_app/user_interface/widgets/my_snakbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/my_button.dart';
import '../../widgets/text_field.dart';

// ignore: must_be_immutable
class OtpScreen extends StatelessWidget {
  final String verificationId;
  OtpScreen({super.key, required this.verificationId});

  @override
  Widget build(BuildContext context) {
    TextEditingController otpControler = TextEditingController();
    final OtpController otpController = Get.put(OtpController());
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Screen"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "One Time Password",
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
            controller: otpControler,
            text: "OTP",
            keyboard: TextInputType.number,
          ),
          SizedBox(
            height: 20,
          ),
          MyButton(
            onPressed: () async {
              String otp = otpControler.text.trim();
              if (otp.isEmpty) {
                SnackbarHelper.showSnackbar("Error", "Plase Enter the OTP");
              } else {
                otpController.verifyOtp(otp, verificationId);
              }
            },
            title: "OTP",
            width: 150,
          )
        ],
      ),
    );
  }
}
