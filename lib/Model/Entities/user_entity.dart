import 'package:flutter_chatx/Model/Constant/const.dart';

class AppUser {
  final String? fullName;
  final String email;
  final String? password;
  final String userUID;

  AppUser({
     this.fullName,
    required this.email,
     this.password,
    required this.userUID,
  });
 
  late final Map<String, dynamic> userEntityJSON = {
    userFullName: this.fullName,
    userEmail: this.email,
    userPassword: this.password,
    userUID: this.userUID
  };
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
