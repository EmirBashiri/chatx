import 'package:flutter/material.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:flutter_chatx/ViewModel/NavigationSystem/SplashNavigation/navigation.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final DependencyController dpController = Get.find();
  late final SplashNavigation splashNavigation =
      dpController.navigationSystem.splashNavigation;
  @override
  void initState() {
    splashNavigation.goToRootScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const CustomLoadingScreen();
  }
}
