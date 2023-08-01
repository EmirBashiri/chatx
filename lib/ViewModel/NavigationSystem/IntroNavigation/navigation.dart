import 'package:flutter/material.dart';
import 'package:flutter_chatx/View/Screens/AuthenticationScreen/authentication_screen.dart';
import 'package:get/get.dart';

class IntroNavigation {
  void goToAuthScreen() {
    Navigator.pushReplacement(
      Get.context!,
      MaterialPageRoute(
        builder: (context) => const AuthenticationScreen(),
      ),
    );
  }
}
