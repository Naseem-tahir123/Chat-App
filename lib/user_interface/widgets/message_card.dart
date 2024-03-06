import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Api/apis.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/utils/app_constants.dart';
import 'package:chat_app/utils/mydate_util.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  MessageCard({super.key, required this.message});
  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return ApIs.user.uid == widget.message.fromId ? _Sender() : _Receiver();
  }

  // our message
  Widget _Sender() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            if (widget.message.read.isNotEmpty)
              Icon(
                Icons.done_all_rounded,
                color: AppConstant.appMainColor,
                size: 20,
              ),
            SizedBox(
              width: 5,
            ),
            Text(
              MyDateUtil.getformatedTime(
                  context: context, time: widget.message.sent),
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ? 5 : 15),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: AppConstant.appScendoryColor,
                border: Border.all(color: AppConstant.appMainColor),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15))),
            child: widget.message.type == Type.text
                ?
                // show text
                Text(widget.message.msg)
                // show image
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

// Other messages
  Widget _Receiver() {
    // update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      ApIs.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ? 5 : 15),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color: AppConstant.appMainColor),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            // child: Text(widget.message.msg),

            child: widget.message.type == Type.text
                ?
                // show text
                Text(widget.message.msg)
                // show image
                : ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      errorWidget: (context, url, error) => Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Text(
            MyDateUtil.getformatedTime(
                context: context, time: widget.message.sent),
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        )
      ],
    );
  }
}
