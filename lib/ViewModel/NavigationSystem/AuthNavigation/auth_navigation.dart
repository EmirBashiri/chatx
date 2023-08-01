import 'package:flutter/material.dart';
import 'package:flutter_chatx/View/Screens/HomeScreen/home_screen.dart';
import 'package:get/get.dart';

class AuthNavigation {
  // Navigate to home screen function
  void goToHomeScreen() {
    Navigator.pushReplacement(
      Get.context!,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }
}
