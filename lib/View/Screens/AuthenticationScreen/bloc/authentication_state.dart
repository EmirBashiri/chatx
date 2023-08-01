part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoadingScreen extends AuthenticationState {}

class AuthenticationErrorScreen extends AuthenticationState {
  final String errorMessage;

  AuthenticationErrorScreen(this.errorMessage);
}

class AuthenticationSignupScreen extends AuthenticationState {}

class AuthenticationLoginScreen extends AuthenticationState {}
