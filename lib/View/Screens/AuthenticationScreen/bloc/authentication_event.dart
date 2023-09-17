part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

// This event is called whenever the authentication screen is seting up
class AuthenticationStart extends AuthenticationEvent {}

// This event is called whenever the user taps to switch login mode
class AuthenticationGoLogin extends AuthenticationEvent {}

// This event is called whenever the user taps to switch signup mode
class AuthenticationGoSignUp extends AuthenticationEvent {}

// This event is called whenever the user taps to signup
class AuthenticationSignup extends AuthenticationEvent {
  final UserEntity userEntity;
  final bool isPrivacyAgreed;

  AuthenticationSignup(
      {required this.userEntity, required this.isPrivacyAgreed});
}

// This event is called whenever the user taps to login
class AuthenticationLogin extends AuthenticationEvent {
  final UserEntity userEntity;

  AuthenticationLogin(this.userEntity);
}

// This event is called whenever the user taps to Continue With Google
class AuthenticationContinueWithGoogle extends AuthenticationEvent {}
