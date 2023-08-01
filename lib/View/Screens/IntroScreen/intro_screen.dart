import 'package:flutter/material.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:flutter_chatx/ViewModel/NavigationSystem/IntroNavigation/navigation.dart';
import 'package:flutter_chatx/ViewModel/NavigationSystem/navigation_system.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final NavigationSystem navigationSystem =
        Get.find<DependencyController>().navigationSystem;
    final IntroNavigation splashNavigation = navigationSystem.introNavigation;
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
                      introMainContent,
                      style: textTheme.headlineLarge!.copyWith(
                        color: colorScheme.background,
                      ),
                    ),
                    CustomButton(
                      title: introGetStarted,
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
