import 'package:flutter/cupertino.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/View/Theme/theme.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/app_functions.dart';
import 'package:flutter_chatx/ViewModel/NavigationSystem/navigation_system.dart';
import 'package:get/get.dart';

//Application dependencies controller
class DependencyController extends GetxController {
  // Instance of navigation system class
  final NavigationSystem navigationSystem = NavigationSystem();
  // Instance of app functions class
  final AppFunctions appFunctions = AppFunctions();
  // Instance of custom theme class
  final CustomTheme customTheme = CustomTheme();
}

// Message sender controller
class MessageSenderController extends GetxController {
  // This boolean using in message sender part of app
  RxBool canSendText = false.obs;

  // This TextEditingController using in message sender part of app as user's typed text
  TextEditingController senderTextController = TextEditingController();

  // This list is using to access last chat's message list
  List<MessageEntity> messageList = [];
}
