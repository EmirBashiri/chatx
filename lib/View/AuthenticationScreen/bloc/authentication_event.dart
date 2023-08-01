part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class AuthenticationStart extends AuthenticationEvent {}

class AuthenticationGoLogin extends AuthenticationEvent {}

class AuthenticationGoSignUp extends AuthenticationEvent {}

class AuthenticationSignup extends AuthenticationEvent {
  final UserEntity userEntity;
  final bool isPrivacyAgreed;

  AuthenticationSignup(
      {required this.userEntity, required this.isPrivacyAgreed});
}

class AuthenticationLogin extends AuthenticationEvent {
  final UserEntity userEntity;

  AuthenticationLogin(this.userEntity);
}

class AuthenticationContinueWithGoogle extends AuthenticationEvent {}
