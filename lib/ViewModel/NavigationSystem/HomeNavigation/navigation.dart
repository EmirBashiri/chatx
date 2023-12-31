import 'package:flutter/material.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/chat_screen.dart';
import 'package:flutter_chatx/View/Screens/SettingsScreen/settings_screen.dart';
import 'package:get/get.dart';

class HomeNavigation {
  // Navigate to chat screen
  void goToChatScreen(
      {required AppUser senderUser, required AppUser receiverUser}) {
    Navigator.push(
      Get.context!,
      MaterialPageRoute(
        builder: (context) =>
            ChatScreen(senderUser: senderUser, receiverUser: receiverUser),
      ),
    );
  }

  // Navigate to setting screen
  void goToSettingScreen({required AppUser currentUser}) {
    Navigator.push(
      Get.context!,
      MaterialPageRoute(
        builder: (context) => SettingScreen(currentUser: currentUser),
      ),
    );
  }
}
