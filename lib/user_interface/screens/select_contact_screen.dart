import 'package:chat_app/Api/apis.dart';
import 'package:chat_app/controllers/home_screen_controller.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/user_interface/widgets/chat_user_cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/my_snakbar.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({super.key});

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  //for storing all users
  List<UserModel> _list = [];
  //for storing all search items
  final List<UserModel> _searchList = [];
  //for storing the search status
  bool _isSearching = false;

  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () async {
          if (homeScreenController.isSearching) {
            homeScreenController.toggleSearch();

            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: _isSearching
                ? Card(
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search..",
                          hintStyle: TextStyle(color: Colors.black54)),
                      autofocus: true,
                      style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 1,
                          color: Colors.black54),
                      onChanged: (val) {
                        //search logic
                        _searchList.clear();
                        for (var i in _list) {
                          if (i.username.contains(val.toLowerCase()) ||
                              i.email.contains(val.toLowerCase())) {
                            _searchList.add(i);
                          }
                          setState(() {
                            _searchList;
                          });
                        }
                      },
                    ),
                  )
                : Text("Select Contact"),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(
                  _isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  _addChatUserDialog();
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              )
            ],
          ),
          body: StreamBuilder(
              stream: ApIs.getMyFriendsId(),
              // for getting id of only known frieds
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return StreamBuilder(
                        stream: ApIs.getAllUsers(
                            snapshot.data?.docs.map((e) => e.id).toList() ??
                                []),
                        // get only those users whose id's are provided
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = snapshot.data?.docs;
                              _list = data
                                      ?.map((e) => UserModel.fromMap(e.data()))
                                      .toList() ??
                                  [];
                              if (_list.isNotEmpty) {
                                return ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: _isSearching
                                        ? _searchList.length
                                        : _list.length,
                                    itemBuilder: (context, index) {
                                      return UserCart(
                                          user: _isSearching
                                              ? _searchList[index]
                                              : _list[index]);
                                    });
                              } else {
                                return Center(
                                  child: Text("No Data Found"),
                                );
                              }
                          }
                        });
                }
              }),
        ),
      ),
    );
  }
  // *******************Dialog box to add new user*****************

  void _addChatUserDialog() {
    String cellNumber = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: Row(
                children: const [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text('  Add User')
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => cellNumber = value,
                decoration: InputDecoration(
                    hintText: 'phone number',
                    prefixIcon: const Icon(Icons.phone, color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Get.back();
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.blue, fontSize: 16))),

                //add button
                MaterialButton(
                    onPressed: () async {
                      //hide alert dialog
                      Get.back();
                      if (cellNumber.isNotEmpty) {
                        await ApIs.addChatUser(cellNumber).then((value) {
                          if (!value) {
                            SnackbarHelper.showSnackbar(
                                "Error", "User not exists");
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}
