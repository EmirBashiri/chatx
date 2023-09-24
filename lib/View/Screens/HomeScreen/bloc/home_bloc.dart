import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/HomeFunctions/home_functions.dart';
import 'package:get/get.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DependencyController dpController = Get.find();
  late final HomeFunctioins homeFunctioins =
      dpController.appFunctions.homeFunctioins;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Instance of the current user to use in other states
  AppUser? currentUser;

  // This function is called whenever the event is HomeStart
  void homeStart(
      {required HomeFunctioins homeFunctioins, required Emitter emit}) {
    emit(HomeLoadingScreen());
    homeFunctioins.listenToUsers(homeBloc: this);
  }

  // This function is called whenever the event is HomeUpdate
  void homeUpdate(
      {required List<AppUser> userListFromDB,
      required HomeFunctioins homeFunctioins,
      required Emitter emit}) {
    emit(HomeLoadingScreen());
    final List<AppUser> userList = userListFromDB;
    final AppUser currentUser = homeFunctioins.fetchCurrentUser(
        userList: userList, firebaseCurrentUser: firebaseAuth.currentUser!);
    // Save current user to use in other states
    this.currentUser = currentUser;
    emit(HomeMainScreen(userList: userList, currnetUser: currentUser));
  }

  // This function is called whenever the event is HomeError
  void homeError({required dynamic errorExecption, required Emitter emit}) {
    if (errorExecption is FirebaseException) {
      emit(HomeErrorScreen(
          errorMessage: errorExecption.message ?? defaultErrorMessage,
          currentUser: currentUser));
    } else {
      emit(HomeErrorScreen(
          errorMessage: defaultErrorMessage, currentUser: currentUser));
    }
  }

  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeStart) {
        homeStart(homeFunctioins: homeFunctioins, emit: emit);
      } else if (event is HomeUpdate) {
        homeUpdate(
          userListFromDB: event.userList,
          homeFunctioins: homeFunctioins,
          emit: emit,
        );
      } else if (event is HomeError) {
        homeError(errorExecption: event.errorExecption, emit: emit);
      }
    });
  }
}
