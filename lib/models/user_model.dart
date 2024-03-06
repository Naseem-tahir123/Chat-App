// ignore_for_file: file_names

class UserModel {
  String uId;
  String username;
  String email;
  String phone;
  String userImg;
  String userDeviceToken;
  String country;
  String pushToken;
  String isActive;
  bool isAdmin;
  bool isOnline;
  dynamic createdOn;
  String city;

  UserModel({
    required this.uId,
    required this.username,
    required this.email,
    required this.phone,
    required this.userImg,
    required this.userDeviceToken,
    required this.country,
    required this.pushToken,
    required this.isActive,
    required this.isAdmin,
    required this.isOnline,
    required this.createdOn,
    required this.city,
  });

  // Serialize the UserModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'username': username,
      'email': email,
      'phone': phone,
      'userImg': userImg,
      'userDeviceToken': userDeviceToken,
      'country': country,
      'pushToken': pushToken,
      'isActive': isActive,
      'isAdmin': isAdmin,
      'isOnline': isOnline,
      'createdOn': createdOn,
      'city': city,
    };
  }

  // Create a UserModel instance from a JSON map
  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      uId: json['uId'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      userImg: json['userImg'],
      userDeviceToken: json['userDeviceToken'],
      country: json['country'],
      pushToken: json['pushToken'],
      isActive: json['isActive'],
      isAdmin: json['isAdmin'],
      isOnline: json['isOnline'],
      createdOn: json['createdOn'].toString(),
      city: json['city'],
    );
  }
}
