import 'package:flutter/material.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:flutter_chatx/ViewModel/NavigationSystem/SplsahNavigation/navigation.dart';
import 'package:flutter_chatx/ViewModel/NavigationSystem/navigation_system.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final NavigationSystem navigationSystem =
        Get.find<DependencyController>().navigationSystem;
    final SplashNavigation splashNavigation = navigationSystem.splashNavigation;
    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Flexible(flex: 2, child: SvgPicture.asset(splashImagePath)),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      splashMainContent,
                      style: textTheme.headlineLarge!.copyWith(
                        color: colorScheme.background,
                      ),
                    ),
                    CustomButton(
                      title: splashGetStarted,
                      backgroundColor: colorScheme.background,
                      onPressed: () => splashNavigation.goToAuthScreen(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
