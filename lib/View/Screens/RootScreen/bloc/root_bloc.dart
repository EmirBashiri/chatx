import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // This function is called whenever the event is RootStart
  void rootStart({required Emitter emit}) {
    if (firebaseAuth.currentUser != null) {
      emit(RootShowHomeScreen());
    } else {
      emit(RootShowIntro());
    }
  }

  RootBloc() : super(RootInitial()) {
    on<RootEvent>(
      (event, emit) {
        if (event is RootStart) {
          rootStart(emit: emit);
        }
      },
    );
  }
}
