import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/HomeFunctions/home_functions.dart';
import 'package:get/get.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    final DependencyController dpController = Get.find();
    final HomeFunctioins homeFunctioins =
        dpController.appFunctions.homeFunctioins;
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    on<HomeEvent>((event, emit) async {
      if (event is HomeStart) {
        emit(HomeLoadingScreen());
        homeFunctioins.listenToUsers(homeBloc: this);
      } else if (event is HomeFechUserList) {
        final List<AppUser> userList = event.userList;
        final AppUser currnetUser = homeFunctioins.fechCurrentUser(
            userList: userList, firebaseCurrentUser: firebaseAuth.currentUser!);

        emit(HomeMainScreen(userList: userList, currnetUser: currnetUser));
      }
    });
  }
}
