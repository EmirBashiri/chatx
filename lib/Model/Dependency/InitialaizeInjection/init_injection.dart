import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/FireBase/firebase_options.dart';
import 'package:get/get.dart';

class InitialaizeDependencies {
  static Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    Get.put(MessageSenderController());
    Get.put(DependencyController());
  }
}
