import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) {
      if (event is AuthenticationStart) {
        emit(AuthenticationSignUp());
      } else if (event is AuthenticationGoSignUp) {
        emit(AuthenticationSignUp());
      } else if (event is AuthenticationGoLogin) {
        emit(AuthenticationLogin());
      }
    });
  }
}
