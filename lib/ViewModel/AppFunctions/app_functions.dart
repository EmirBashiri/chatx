import 'package:flutter_chatx/ViewModel/AppFunctions/AuthFunctions/auth_functions.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/chat_function.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/HomeFunctions/home_functions.dart';

class AppFunctions {
  // Instance of Auth functions class
  final AuthFunctions authFunctions = AuthFunctions();

  // Instance of Home functions class
  final HomeFunctioins homeFunctioins = HomeFunctioins();

  // Instance of Chat functions class
  final ChatFunctions chatFunctions = ChatFunctions();
}
