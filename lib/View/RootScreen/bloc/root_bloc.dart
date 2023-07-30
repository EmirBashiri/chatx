import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  RootBloc() : super(RootInitial()) {
    on<RootEvent>(
      (event, emit) {
        if (event is RootStart) {
          // TODO Check authentication status
          emit(RootShowSplash());
        }
      },
    );
  }
}
