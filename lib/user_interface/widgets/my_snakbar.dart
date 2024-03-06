import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarHelper {
  static void showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xff764abc).withOpacity(0.7),
      colorText: Colors.white,
    );
  }
}
