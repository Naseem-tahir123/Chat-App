import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Api/apis.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/user_interface/widgets/dialog_profile.dart';
import 'package:chat_app/utils/app_constants.dart';
import 'package:chat_app/utils/mydate_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/chat_screen.dart';

class UserCart extends StatefulWidget {
  final UserModel user;
  const UserCart({super.key, required this.user});

  @override
  State<UserCart> createState() => _UserCartState();
}

class _UserCartState extends State<UserCart> {
  // last message info (if null no messages)
  Message? _message;
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: mq.width * .02, vertical: 4),
      child: InkWell(
          onTap: () {
            Get.to(() => ChatScreen(
                  user: widget.user,
                ));
          },
          child: StreamBuilder(
              stream: ApIs.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

                if (list.isNotEmpty) _message = list[0];

                return ListTile(
                  leading: InkWell(
                    onTap: () {
                      Get.to(() => ProfileDialog(user: widget.user));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        height: mq.height * .16,
                        width: mq.width * .16,
                        imageUrl: widget.user.userImg,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            CircleAvatar(child: Icon(CupertinoIcons.person)),
                      ),
                    ),
                  ),

                  // user name
                  title: Text(widget.user.username.isNotEmpty
                      ? widget.user.username
                      : "No Name"),

                  //last message
                  subtitle: Text(
                    _message != null
                        ? _message!.type == Type.image
                            ? "image"
                            : _message!.msg
                        : widget.user.phone,
                    style: TextStyle(color: Colors.black54),
                  ),
                  trailing: _message == null
                      ? null // show nothing when no message is sent
                      : _message!.read.isEmpty &&
                              _message!.fromId != ApIs.user.uid
                          ?
                          // show when message is unread
                          Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                  color: AppConstant.appScendoryColor,
                                  borderRadius: BorderRadius.circular(10)),
                            )
                          :
                          // message sent time
                          Text(
                              MyDateUtil.getLastMessageTime(
                                  context: context, time: _message!.sent),
                              style: TextStyle(color: Colors.black54),
                            ),
                );
              })),
    );
  }
}
