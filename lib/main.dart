import 'package:flutter/material.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Dependency/InitialaizeInjection/init_injection.dart';
import 'package:flutter_chatx/Model/Theme/theme.dart';
import 'package:flutter_chatx/View/RootScreen/root_screen.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InitialaizeDependencies.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomTheme customTheme=Get.find<DependencyController>().customTheme;
    return GetMaterialApp(
      title: appName,
      theme: customTheme.themeData,
      home: const RootScreen(),
    );
  }
}
