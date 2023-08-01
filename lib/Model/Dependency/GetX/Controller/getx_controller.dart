import 'package:flutter_chatx/View/Theme/theme.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/app_functions.dart';
import 'package:flutter_chatx/ViewModel/NavigationSystem/navigation_system.dart';
import 'package:get/get.dart';

class DependencyController extends GetxController {
  // Instance of navigation system class
  final NavigationSystem navigationSystem = NavigationSystem();
  // Instance of app functions class
  final AppFunctions appFunctions = AppFunctions();
  // Instance of custom theme class
  final CustomTheme customTheme = CustomTheme();
}
