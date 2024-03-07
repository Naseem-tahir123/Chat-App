import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

class ApIs {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

// for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instanceFor(
      app: Firebase.app(), bucket: "apna-chat-app-d3a40.appspot.com");

// for accessing cloud firestore data base
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

// to return current user
  static User get user => auth.currentUser!;

  // for accessing firebase messaging (push notifications)
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  // for getting firebase message token
  static Future<void> getFirebaseMessageToken() async {
    await firebaseMessaging.requestPermission();
    await firebaseMessaging.getToken().then((t) {
      if (t != null) {
        myself.pushToken = t;
        log("Push Token: $t");
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Got a message whilst in the foreground");
      log("Message Data: ${message.data}");

      if (message.notification != null) {
        log(" Message also contained a notification: ${message.notification}");
      }
    });
  }

// for sending push notification
  static Future<void> sendPushNotification(
      UserModel chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": chatUser.username,
          "body": msg,
          "android_channel_id": "chats"
        },
        "data": {
          "some_data": "User ID: ${myself.uId}",
        },
      };
      var res = await post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader:
                "key=AAAAPRJJ8aA:APA91bHOjtIHd49vaSUXX5QZZLn5PSuRMsWRhIuaYh0QNYbFYghETm9gNJmRyGJUsE3SQQAvPJL5Wm7NPl9oAnVYmOrfmIavLcgES2niSwoTB-3w0haKrYDAw0wdcTJ4ETmtx5hsJ-ja"
          },
          body: jsonEncode(body));
      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');
    } catch (e) {
      log("\nsendPushNotification: $e");
    }
  }

  static UserModel myself = UserModel(
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

// for checking user exist or not
  static Future<bool> userExists() async {
    return (await firestore.collection("users").doc(user.uid).get()).exists;
  }

// for add user for conversation
  static Future<bool> addChatUser(String number) async {
    final data = await firestore
        .collection("users")
        .where("phone", isEqualTo: number)
        .get();
    log("Data: ${data.docs}");
    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      // user exists
      log("User Exists: ${data.docs.first.data()}");
      firestore
          .collection("users")
          .doc(user.uid)
          .collection("my_friends")
          .doc(data.docs.first.id)
          .set({});
      return true;
    } else {
      // user does not exist
      return false;
    }
  }

  //for getting current user information
  static currentUserinfo() async {
    await firestore.collection("users").doc(user.uid).get().then((user) async {
      if (user.exists) {
        myself = UserModel.fromMap(user.data()!);
        await getFirebaseMessageToken();
      } else {
        await createNewUser().then((value) => currentUserinfo());
      }
    });
  }

  //create new user
  static Future<void> createNewUser() async {
    final userModel = UserModel(
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

    return await firestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
  }

// for getting all friends user id form firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyFriendsId() {
    return firestore
        .collection("users")
        .doc(user.uid)
        .collection("my_friends")
        .snapshots();
  }

//*****************Get only chated friends***************

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyChattedFriendsId() {
    return firestore
        .collection("chats")
        .where("fromId", isEqualTo: user.uid)
        .snapshots();
  }

// for getting all users form firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<dynamic> userIds) {
    {
      if (userIds.isNotEmpty) {
        log("\nUserIds: $userIds");
        return firestore
            .collection("users")
            .where("uId", whereIn: userIds.map((id) => id.toString()).toList())
            .snapshots();
      } else {
        // Handle the case where userIds is empty
        // For example, you can return an empty stream
        return Stream.empty();
      }
    }
  }

  // for adding a user to my_friends when first message is send
  static Future<void> sendFirstMessage(
      UserModel chatUser, String msg, Type type) {
    return firestore
        .collection("users")
        .doc(chatUser.uId)
        .collection("my_friends")
        .doc(user.uid)
        .set({}).then((value) => sendMessage(msg, chatUser, type));
  }

// for updating user info
  static Future<void> updateUserInfo() async {
    await firestore
        .collection("users")
        .doc(user.uid)
        .update({"username": myself.username, "phone": myself.phone});
  }

  //update profile image
  static Future<void> updateProfileImage(File file) async {
    final ext = file.path.split(".").last;
    final ref = storage.ref().child("profileImage/${user.uid}.$ext");

    //uploading profile image
    await ref
        .putFile(file, SettableMetadata(contentType: "image/$ext"))
        .then((p0) {
      print("Data transferred: ${p0.bytesTransferred / 1000} kb");
    });

    //updating profile image
    myself.userImg = await ref.getDownloadURL();
    await firestore
        .collection("users")
        .doc(user.uid)
        .update({"userImg": myself.userImg});
  }

  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      UserModel user) {
    return firestore
        .collection("users")
        .where("uId", isEqualTo: user.uId)
        .snapshots();
  }

  // update last active time or online status of a user

  static Future<void> updateLastActiveTime(bool is_online) async {
    firestore.collection("users").doc(user.uid).update({
      'isOnline': is_online,
      "lastActive": DateTime.now().millisecondsSinceEpoch.toString(),
      "pushToken": myself.pushToken,
    });
  }

  ///***************************Chat Screeen Relatied APIs **************************/

  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';
// for getting all messages of a specific conversation firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserModel user) {
    return firestore
        .collection("chats/${getConversationId(user.uId)}/messages")
        .orderBy("sent", descending: true)
        .snapshots();
  }

  // create chat room
  static Future<ChatModel?> createChat(UserModel chatUser) async {
    ChatModel? chats;
    QuerySnapshot snapshot = await firestore
        .collection("chats")
        .where("participants.${chatUser.uId}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      // fetch the existing one
      var docData = snapshot.docs[0].data();
      ChatModel existingChat =
          ChatModel.fromMap(docData as Map<String, dynamic>);
      chats = existingChat;
    } else {
      ChatModel newChats = ChatModel(
        chatroomid: getConversationId(chatUser.uId),
        lastMessage: "",
        participants: {
          user.uid: true,
          chatUser.uId: true,
        },
      );
      await firestore
          .collection("chats")
          .doc(getConversationId(chatUser.uId))
          .set(newChats.toMap());

      chats = newChats;
    }
    return chats;
  }

  // for sending message
  static Future<void> sendMessage(
      String msg, UserModel chatUser, Type type) async {
    // message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    // message to send
    final Message message = Message(
        msg: msg,
        toId: chatUser.uId,
        read: "",
        type: type,
        fromId: user.uid,
        sent: time);

    final ref = firestore
        .collection("chats/${getConversationId(chatUser.uId)}/messages");
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser, type == Type.text ? msg : "image"));
  }

  // update read status of message
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection("chats/${getConversationId(message.fromId)}/messages")
        .doc(message.sent)
        .update({"read": DateTime.now().millisecondsSinceEpoch.toString()});
  }

// get only last message of specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      UserModel user) {
    return firestore
        .collection("chats/${getConversationId(user.uId)}/messages")
        .orderBy("sent", descending: true)
        .limit(1)
        .snapshots();
  }

  // send chat image
  static Future<void> sendChatImage(UserModel chatUser, File file) async {
    // getting image file extension
    final ext = file.path.split(".").last;
    print("extenstion: $ext");

    final ref = storage.ref().child(
        "images/${getConversationId(chatUser.uId)}/${DateTime.now().millisecondsSinceEpoch}.$ext");

    // uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print("Data transferred:${p0.bytesTransferred / 1000} kb");
    });

    // updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(imageUrl, chatUser, Type.image);
  }
}
