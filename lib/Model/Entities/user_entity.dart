import 'package:flutter_chatx/Model/Constant/const.dart';

// Apps user entity
class AppUser {
  final String? fullName;
  final String email;
  final String? password;
  final String userUID;
  final String profileImageUrl;

  AppUser({
    this.fullName,
    required this.email,
    this.password,
    required this.userUID,
    this.profileImageUrl = defaultUserProfileUrl,
  });

  static Map<String, dynamic> userEntityToJSON({required AppUser appUser}) {
    return {
      userFullName: appUser.fullName,
      userEmail: appUser.email,
      userPassword: appUser.password,
      userUid: appUser.userUID,
      userProfileUrl: appUser.profileImageUrl
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
        fullName: json[userFullName],
        email: json[userEmail],
        password: json[userPassword],
        userUID: json[userUid],
        profileImageUrl: json[userProfileUrl]);
  }
}

// Entirty that come from controllers
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
