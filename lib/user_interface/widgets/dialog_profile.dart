import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/user_interface/screens/view_profile_screen%20copy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_constants.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: 200,
        height: 300,
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Positioned(
                  child: Text(
                    user.username,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.to(() => ViewProfileScreen(user: user));
                  },
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: AppConstant.appScendoryColor,
                    size: 25,
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(90),
                child: CachedNetworkImage(
                  height: 180,
                  width: 180,
                  imageUrl: user.userImg,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
