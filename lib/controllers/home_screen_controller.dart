import 'dart:developer';

import 'package:chat_app/Api/apis.dart';
import 'package:chat_app/user_interface/screens/profile_screen.dart';
import 'package:chat_app/user_interface/widgets/my_snakbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class HomeScreenController extends GetxController {
  final TextEditingController searchController = TextEditingController();
//  for storing all users
  List<UserModel> _list = [];

// for storing all search items
  final List<UserModel> searchList = [];

  // for storing  the search status
  var isSearching = false;

  @override
  void onInit() {
    super.onInit();
    ApIs.currentUserinfo();
    // set user status to active
    ApIs.updateLastActiveTime(true);
    // updates user active status according to lifecycle events
    //   // resume -- active or online
    //   // pause -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      debugPrint("message: $message");
      log('message: $message');

      if (ApIs.auth.currentUser != null) {
        if (message.toString().contains("resumed"))
          ApIs.updateLastActiveTime(true);
        if (message.toString().contains("paused"))
          ApIs.updateLastActiveTime(false);
      }
      return Future.value(message);
    });
  }

  void toggleSearch() {
    isSearching = !isSearching;
    // if (!isSearching) {
    //   searchController.clear();
    //   searchList.clear();
    // }
    update();
  }

  void searchUser(String query) {
    searchList.clear();
    for (var user in _list) {
      if (user.username.contains(query.toLowerCase()) ||
          user.email.contains(query.toLowerCase())) {
        searchList.add(user);
      }
    }
    update();
  }

  Future<void> addChatUser(String cellNumber) async {
    if (cellNumber.isNotEmpty) {
      await ApIs.addChatUser(cellNumber).then((value) {
        if (!value) {
          SnackbarHelper.showSnackbar("Error", "User not exists");
        }
      });
    }
  }

  void goToProfileScreen() {
    Get.to(() => ProfileScreen(user: ApIs.myself));
  }

  void updateSearchList(List<UserModel> newList) {
    _list = newList;
    update();
  }

  List<UserModel> get userList => isSearching ? searchList : _list;

  List<String> _chattedUserIds = [];

  List<String> get chattedUserIds => _chattedUserIds;

  // Method to add a user ID to the list of chatted users
  void addChattedUserId(String userId) {
    if (!_chattedUserIds.contains(userId)) {
      _chattedUserIds.add(userId);
      update();
    }
  }

  // Method to remove a user ID from the list of chatted users
  void removeChattedUserId(String userId) {
    _chattedUserIds.remove(userId);
    update();
  }
}
