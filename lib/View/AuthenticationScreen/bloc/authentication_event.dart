part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class AuthenticationStart extends AuthenticationEvent {}

class AuthenticationGoLogin extends AuthenticationEvent {}

class AuthenticationGoSignUp extends AuthenticationEvent {}
