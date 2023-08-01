import 'package:flutter_chatx/ViewModel/NavigationSystem/AuthNavigation/auth_navigation.dart';
import 'package:flutter_chatx/ViewModel/NavigationSystem/IntroNavigation/navigation.dart';
import 'package:flutter_chatx/ViewModel/NavigationSystem/SplashNavigation/navigation.dart';

class NavigationSystem {
  // intro Screen navigation system
  final IntroNavigation introNavigation = IntroNavigation();

  // Auth screen navigaton system
  final AuthNavigation authNavigation = AuthNavigation();

  // splash screen navigaton system
  final SplashNavigation splashNavigation = SplashNavigation();
}
