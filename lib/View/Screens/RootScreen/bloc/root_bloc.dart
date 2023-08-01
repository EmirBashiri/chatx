import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  RootBloc() : super(RootInitial()) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    on<RootEvent>(
      (event, emit) {
        if (event is RootStart) {
          if (firebaseAuth.currentUser != null) {
            emit(RootShowHomeScreen());
          } else {
            emit(RootShowIntro());
          }
        }
      },
    );
  }
}
