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
  final DependencyController dpController = Get.find();
  late final AuthFunctions authFunctions =
      dpController.appFunctions.authFunctions;
  late final AuthNavigation authNavigation =
      dpController.navigationSystem.authNavigation;

  // This function is called whenever the event is AuthenticationSignup
  Future<void> authenticationSignup(
      {required Emitter emit,
      required UserEntity userEntity,
      required bool isPrivacyAgreed}) async {
    emit(AuthenticationLoadingScreen());
    try {
      await authFunctions.signup(
        userEntity: userEntity,
        isPrivacyAgreed: isPrivacyAgreed,
      );
      authNavigation.goToHomeScreen();
    } on FirebaseAuthException catch (error) {
      emit(AuthenticationErrorScreen(error.message ?? defaultErrorMessage));
    }
  }

  // This function is called whenever the event is AuthenticationLogin
  Future<void> authenticationLogin(
      {required Emitter emit, required UserEntity userEntity}) async {
    emit(AuthenticationLoadingScreen());
    try {
      await authFunctions.login(userEntity: userEntity);
      authNavigation.goToHomeScreen();
    } on FirebaseAuthException catch (error) {
      emit(AuthenticationErrorScreen(error.message ?? defaultErrorMessage));
    }
  }

  // This function is called whenever the event is AuthenticationContinueWithGoogle
  Future<void> authenticationContinueWithGoogle({required Emitter emit}) async {
    emit(AuthenticationLoadingScreen());
    try {
      await authFunctions.continueWithGoogle();
      authNavigation.goToHomeScreen();
    } on FirebaseAuthException catch (error) {
      emit(AuthenticationErrorScreen(error.message ?? defaultErrorMessage));
    }
  }

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) async {
      if (event is AuthenticationStart) {
        emit(AuthenticationSignupScreen());
      } else if (event is AuthenticationGoSignUp) {
        emit(AuthenticationSignupScreen());
      } else if (event is AuthenticationGoLogin) {
        emit(AuthenticationLoginScreen());
      } else if (event is AuthenticationSignup) {
        await authenticationSignup(
          emit: emit,
          userEntity: event.userEntity,
          isPrivacyAgreed: event.isPrivacyAgreed,
        );
      } else if (event is AuthenticationLogin) {
        await authenticationLogin(emit: emit, userEntity: event.userEntity);
      } else if (event is AuthenticationContinueWithGoogle) {
        await authenticationContinueWithGoogle(emit: emit);
      }
    });
  }
}
