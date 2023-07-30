part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSignUp extends AuthenticationState {}

class AuthenticationLogin extends AuthenticationState {}
