import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:flutter/material.dart';

class ViewProfileScreen extends StatefulWidget {
  final UserModel user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.user.username.isEmpty ? widget.user.username : "Unknown"),
      ),
      floatingActionButton: Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Joined On: ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(
              width: 2,
            ),
            Text("24 December 2023")
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: CachedNetworkImage(
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                  imageUrl: widget.user.userImg,
                  errorWidget: (context, url, error) => CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(widget.user.email),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Name: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.user.username,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// bottom of chat screen
}
