import 'package:flutter_chatx/ViewModel/NavigationSystem/AuthNavigation/auth_navigation.dart';
import 'package:flutter_chatx/ViewModel/NavigationSystem/HomeNavigation/navigation.dart';
import 'package:flutter_chatx/ViewModel/NavigationSystem/IntroNavigation/navigation.dart';
import 'package:flutter_chatx/ViewModel/NavigationSystem/SettingsNavigation/navigation.dart';
import 'package:flutter_chatx/ViewModel/NavigationSystem/SplashNavigation/navigation.dart';

class NavigationSystem {
  // intro Screen navigation system
  final IntroNavigation introNavigation = IntroNavigation();

  // Auth screen navigaton system
  final AuthNavigation authNavigation = AuthNavigation();

  // splash screen navigaton system
  final SplashNavigation splashNavigation = SplashNavigation();

  // home screen navigaton system
  final HomeNavigation homeNavigation = HomeNavigation();

  // settings screen navigaton system
  final SettingsNavigation settingsNavigation = SettingsNavigation();
}
