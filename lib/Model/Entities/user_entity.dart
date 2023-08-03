import 'package:flutter_chatx/Model/Constant/const.dart';

class AppUser {
  final String? fullName;
  final String email;
  final String? password;
  final String userUID;
  final String profileUrl;

  AppUser({
    this.fullName,
    required this.email,
    this.password,
    required this.userUID,
    this.profileUrl = defaultUserProfileUrl,
  });

  late final Map<String, dynamic> userEntityToJSON = {
    userFullName: fullName,
    userEmail: email,
    userPassword: password,
    userUid: userUID,
    userProfileUrl: profileUrl
  };

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
        fullName: json[userFullName],
        email: json[userEmail],
        password: json[userPassword],
        userUID: json[userUid],
        profileUrl: json[userProfileUrl]);
  }
}

class UserEntity {
  final String? fullName;
  final String email;
  final String password;

  UserEntity({
    this.fullName,
    required this.email,
    required this.password,
  });
}
