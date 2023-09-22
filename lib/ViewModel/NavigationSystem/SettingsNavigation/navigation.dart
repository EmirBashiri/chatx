import 'package:flutter/material.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:flutter_chatx/View/Screens/SettingsScreen/ProfileEdit/profile_edit_screen.dart';
import 'package:get/get.dart';

class SettingsNavigation {
  void goToEditScreen({required AppUser currentUser}) {
    Navigator.push(
      Get.context!,
      MaterialPageRoute(
        builder: (context) => ProfileEditScreen(currentUser: currentUser),
      ),
    );
  }
}
