import 'package:flutter/material.dart';
import 'package:flutter_chatx/View/Screens/AuthenticationScreen/authentication_screen.dart';
import 'package:get/get.dart';

class SplashNavigation {
  void goToAuthScreen() {
    Navigator.pushReplacement(
      Get.context!,
      MaterialPageRoute(
        builder: (context) => const AuthenticationScreen(),
      ),
    );
  }
}
