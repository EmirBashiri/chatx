import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/AuthFunctions/auth_functions.dart';
import 'package:flutter_chatx/ViewModel/NavigationSystem/AuthNavigation/auth_navigation.dart';
import 'package:get/get.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    final DependencyController dpController = Get.find();
    final AuthFunctions authFunctions = dpController.appFunctions.authFunctions;
    final AuthNavigation authNavigation =
        dpController.navigationSystem.authNavigation;
    on<AuthenticationEvent>((event, emit) async {
      if (event is AuthenticationStart) {
        emit(AuthenticationSignupScreen());
      } else if (event is AuthenticationGoSignUp) {
        emit(AuthenticationSignupScreen());
      } else if (event is AuthenticationGoLogin) {
        emit(AuthenticationLoginScreen());
      } else if (event is AuthenticationSignup) {
        emit(AuthenticationLoadingScreen());
        try {
          await authFunctions.signup(
            userEntity: event.userEntity,
            isPrivacyAgreed: event.isPrivacyAgreed,
          );
          authNavigation.goToHomeScreen();
        } on FirebaseAuthException catch (error) {
          emit(AuthenticationErrorScreen(error.message ?? defaultErrorMessage));
        }
      } else if (event is AuthenticationLogin) {
        emit(AuthenticationLoadingScreen());
        try {
          await authFunctions.login(userEntity: event.userEntity);
          authNavigation.goToHomeScreen();
        } on FirebaseAuthException catch (error) {
          emit(AuthenticationErrorScreen(error.message ?? defaultErrorMessage));
        }
      } else if (event is AuthenticationContinueWithGoogle) {
        emit(AuthenticationLoadingScreen());
        try {
          await authFunctions.continueWithGoogle();
          authNavigation.goToHomeScreen();
        } on FirebaseAuthException catch (error) {
          emit(AuthenticationErrorScreen(error.message ?? defaultErrorMessage));
        }
      }
    });
  }
}
