import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Api/apis.dart';
import 'package:chat_app/controllers/chat_screen_controller.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/user_interface/screens/view_profile_screen%20copy.dart';
import 'package:chat_app/user_interface/widgets/message_card.dart';
import 'package:chat_app/utils/app_constants.dart';
import 'package:chat_app/utils/mydate_util.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/message.dart';

class ChatScreen extends StatefulWidget {
  final UserModel user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // for storing all messages
  List<Message> _list = [];
  final _textController = TextEditingController();
  final ChatScreenController chatScreenController =
      Get.put(ChatScreenController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: AppConstant.appMainColor));

    return GetBuilder<ChatScreenController>(
        init: chatScreenController,
        builder: (chatScreenController) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              chatScreenController.toggleEmoji();
            },
            child: SafeArea(
              // ignore: deprecated_member_use
              child: WillPopScope(
                onWillPop: () {
                  if (chatScreenController.showEmoji) {
                    chatScreenController.toggleEmoji();
                    return Future.value(false);
                  } else {
                    return Future.value(true);
                  }
                },
                child: Scaffold(
                    backgroundColor: AppConstant.appBackgroundColor,
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      flexibleSpace: _appbar(),
                    ),
                    body: Column(
                      children: [
                        Expanded(
                          child: StreamBuilder(
                              stream: ApIs.getAllMessages(widget.user),
                              // stream: ApIs.getAllUsers(),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                  case ConnectionState.none:
                                    return SizedBox();
                                  case ConnectionState.active:
                                  case ConnectionState.done:
                                    final data = snapshot.data?.docs;

                                    _list = data!
                                        .map((e) => Message.fromJson(e.data()))
                                        .toList();
                                    if (_list.isNotEmpty) {
                                      return ListView.builder(
                                          reverse: true,
                                          physics: BouncingScrollPhysics(),
                                          itemCount: _list.length,
                                          itemBuilder: (context, index) {
                                            return MessageCard(
                                                message: _list[index]);
                                          });
                                    } else {
                                      return Center(
                                        child: Text("No anydata"),
                                      );
                                    }
                                }
                              }),
                        ),
                        if (chatScreenController.isUploading)
                          Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 20),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )),
                        _chatInput(chatScreenController),
                        if (chatScreenController.showEmoji)
                          SizedBox(
                            height: 300,
                            child: EmojiPicker(
                              textEditingController: _textController,
                              config: Config(
                                height: 256,
                                checkPlatformCompatibility: true,
                                emojiViewConfig: EmojiViewConfig(
                                  backgroundColor:
                                      AppConstant.appBackgroundColor,
                                  columns: 7,
                                  emojiSizeMax:
                                      32 * (Platform.isIOS ? 1.30 : 1.0),
                                ),
                              ),
                            ),
                          )
                      ],
                    )),
              ),
            ),
          );
        });
  }

  Widget _appbar() {
    return InkWell(
        onTap: () {
          Get.to(() => ViewProfileScreen(user: widget.user));
        },
        child: StreamBuilder(
            stream: ApIs.getUserInfo(widget.user),
            builder: ((context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => UserModel.fromMap(e.data())).toList() ?? [];

              return Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      )),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      width: 40,
                      height: 40,
                      fit: BoxFit.fill,
                      imageUrl: list.isNotEmpty
                          ? list[0].userImg
                          : widget.user.userImg,
                      errorWidget: (context, url, error) => CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        list.isNotEmpty
                            ? list[0].username
                            : widget.user.username,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        list.isNotEmpty
                            ? list[0].isOnline
                                ? "Online"
                                : MyDateUtil.getLastActiveTime(
                                    context: context,
                                    lastActive: list[0].isActive)
                            : MyDateUtil.getLastActiveTime(
                                context: context,
                                lastActive: widget.user.isActive),
                        style: TextStyle(color: Colors.white.withOpacity(0.8)),
                      )
                    ],
                  )
                ],
              );
            })));
  }

  Widget _chatInput(ChatScreenController chatScreenController) {
    return Row(
      children: [
        Expanded(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();

                    chatScreenController.toggleEmoji();
                  },
                  icon: Icon(
                    Icons.emoji_emotions,
                    color: Colors.indigo,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      FocusScope.of(context).unfocus();

                      // chatScreenController.toggleEmoji();
                      if (chatScreenController.showEmoji == true) {
                        chatScreenController.toggleEmoji();
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Type a message",
                      hintStyle:
                          TextStyle(color: Colors.indigo.withOpacity(0.8)),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();

                    // picking multiple images
                    final List<XFile> images =
                        await picker.pickMultiImage(imageQuality: 70);
                    // uploading and sending images one by one
                    for (var i in images) {
                      print("Image Path: ${i.path}");

                      chatScreenController.startUploading();
                      await ApIs.sendChatImage(widget.user, File(i.path));
                      chatScreenController.stopUploading();
                    }
                  },
                  icon: Icon(
                    Icons.image,
                    color: Colors.indigo,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();

                    // pick an image
                    final XFile? image = await picker.pickImage(
                        source: ImageSource.camera, imageQuality: 70);
                    if (image != null) {
                      print(" Image Path: ${image.path}");
                      chatScreenController.startUploading();
                      await ApIs.sendChatImage(widget.user, File(image.path));
                      chatScreenController.stopUploading();
                    }
                  },
                  icon: Icon(
                    Icons.camera,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          ),
        ),
        MaterialButton(
            minWidth: 0,
            padding: EdgeInsets.only(top: 1, left: 10, right: 5, bottom: 2),
            shape: CircleBorder(),
            onPressed: () {
              ApIs.createChat(widget.user);
              if (_textController.text.isNotEmpty) {
                if (_list.isEmpty) {
                  ApIs.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                } else {
                  ApIs.sendMessage(
                      _textController.text, widget.user, Type.text);
                }
                _textController.text = "";
              }
            },
            color: Colors.indigo,
            child: Icon(
              Icons.send,
              color: Colors.white,
            ))
      ],
    );
  }
}
