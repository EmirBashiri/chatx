import 'package:flutter/material.dart';
import 'package:flutter_chatx/View/Screens/RootScreen/root_screen.dart';
import 'package:get/get.dart';

class SplashNavigation {
  // Navigate to home screen
  Future<void> goToRootScreen() async {
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pop(Get.context!);
    Navigator.push(
      Get.context!,
      MaterialPageRoute(
        builder: (context) => const RootScreen(),
      ),
    );
  }
}
