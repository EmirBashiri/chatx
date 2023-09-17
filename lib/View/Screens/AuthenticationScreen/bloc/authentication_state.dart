part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

// This state is launched whenever the authentication is loading
class AuthenticationLoadingScreen extends AuthenticationState {}

// This state is launched whenever an error is detected in the authentication process
class AuthenticationErrorScreen extends AuthenticationState {
  final String errorMessage;

  AuthenticationErrorScreen(this.errorMessage);
}

// This state is launched whenever the operation mode is signup mode
class AuthenticationSignupScreen extends AuthenticationState {}

// This state is launched whenever the operation mode is login mode
class AuthenticationLoginScreen extends AuthenticationState {}
