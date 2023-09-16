import 'package:flutter/material.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';

// TODO implement setting screen  here
class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key, required this.currentUser});
  final AppUser currentUser;
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.tealAccent);
  }
}
