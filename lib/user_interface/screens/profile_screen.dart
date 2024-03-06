import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Api/apis.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/user_interface/widgets/my_button.dart';
import 'package:chat_app/user_interface/widgets/my_snakbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import 'authentication/welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    // var mq = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Profile"),
            actions: [
              IconButton(
                onPressed: () async {
                  await ApIs.updateLastActiveTime(false);
                  await FirebaseAuth.instance.signOut();
                  await GoogleSignIn().signOut();
                  // GoogleSignIn googleSignIn = GoogleSignIn();
                  // googleSignIn.signIn();
                  Get.offAll(() => WelcomeScreen());
                  ApIs.auth = FirebaseAuth.instance;
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Stack(
                      children: [
                        _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(75),
                                child: Image.file(
                                  File(_image!),
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.fill,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(75),
                                child: CachedNetworkImage(
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fill,
                                  imageUrl: widget.user.userImg,
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                                ),
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            color: Colors.white,
                            shape: CircleBorder(),
                            onPressed: () {
                              _showBottomSheet();
                            },
                            child: Icon(Icons.edit, color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(widget.user.email.isNotEmpty
                        ? widget.user.email
                        : "No email address"),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: widget.user.username.isNotEmpty
                          ? widget.user.username
                          : "Name",
                      onSaved: (val) => ApIs.myself.username = val ?? "",
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : "Required Field",
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "Name",
                        label: Text("User Name"),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: widget.user.phone,
                      onSaved: (val) => ApIs.myself.phone = val ?? "",
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : "Required Field",
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "+923400000",
                        label: Text("Phone Number"),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MyButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          ApIs.updateUserInfo();
                          SnackbarHelper.showSnackbar(
                              "Success", "User info is updated");
                        } else {
                          SnackbarHelper.showSnackbar(
                              "Error", "Fields are required");
                        }
                      },
                      width: 150,
                      title: "Update",
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

// bottom of chat screen
  void _showBottomSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 5, bottom: 10),
            children: [
              Text(
                "Choose Your Profile Image",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(100, 80)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
// Pick an image.
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          setState(() {
                            _image = image.path;
                          });
                          ApIs.updateProfileImage(File(_image!));
                          print("Image Path: ${image.path}");
                          Get.back();
                        }
                      },
                      child: Image.asset("assets/images/camera.png")),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(100, 80)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
// Pick an image.
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            _image = image.path;
                          });
                          ApIs.updateProfileImage(File(_image!));

                          print("Image Path: ${image.path}");
                          Get.back();
                        }
                      },
                      child: Image.asset("assets/images/add_image.png"))
                ],
              )
            ],
          );
        });
  }
}
