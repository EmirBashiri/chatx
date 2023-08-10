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
    on<HomeEvent>((event, emit) async {
      if (event is HomeStart) {
        emit(HomeLoadingScreen());
        homeFunctioins.listenToUsers(homeBloc: this);
      } else if (event is HomeFechUserList) {
        emit(HomeMainScreen(event.userList));
      }
    });
  }
}
