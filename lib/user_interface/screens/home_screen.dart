import 'package:chat_app/Api/apis.dart';
import 'package:chat_app/controllers/home_screen_controller.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/user_interface/screens/profile_screen.dart';
import 'package:chat_app/user_interface/screens/select_contact_screen.dart';
import 'package:chat_app/user_interface/widgets/chat_user_cart.dart';
import 'package:chat_app/utils/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                : Text("Apna Chat"),
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
                  Get.to(() => ProfileScreen(
                        user: ApIs.myself,
                      ));
                },
                icon: Icon(
                  Icons.more_vert,
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
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 10),
            child: FloatingActionButton(
              onPressed: () {
                // _addChatUserDialog();
                Get.to(() => SelectContact());
              },
              child: Icon(
                Icons.add_comment_rounded,
                color: Colors.white,
                size: 40,
              ),
              backgroundColor: AppConstant.appScendoryColor,
            ),
          ),
        ),
      ),
    );
  }
}
