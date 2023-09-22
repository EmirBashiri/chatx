import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/SettingsFunctions/settings_functions.dart';
import 'package:get/get.dart';

part 'profile_edit_event.dart';
part 'profile_edit_state.dart';

class ProfileEditBloc extends Bloc<ProfileEditEvent, ProfileEditState> {
  final AppUser currentUser;
  final SettingsFunctions settingsFunctions =
      Get.find<DependencyController>().appFunctions.settingsFunctions;

  // This function is called whenever the event is ProfileEditStart
  void profileEditStart({required Emitter emit}) {
    emit(ProfileEditMainState());
  }

  // This function is called whenever the event is ProfileEditSetAvatar
  Future<void> profileEditSetAvatar({required Emitter emit}) async {
    emit(ProfileEditLoadingState());
    final String? imageFilePath = await settingsFunctions.setNewAvatar();
    if (imageFilePath != null) {
      emit(ProfileEditNewAvatarState(imageFilePath));
    } else {
      emit(ProfileEditMainState());
    }
  }

  // This function is called whenever the event is ProfileEditSaveWithoutAvatar
  Future<void> profileEditSaveWithoutAvatar(
      {required Emitter emit, required UserEntity userEntity}) async {
    emit(ProfileEditLoadingState());
    try {
      await settingsFunctions.saveWithoutAvatar(
        currentUser: currentUser,
        userEntity: userEntity,
      );
      settingsFunctions.returnToHomeScreen();
    } on FirebaseException catch (error) {
      emit(ProfileEditErrorState(error.message ?? defaultErrorMessage));
    }
  }

  // This function is called whenever the event is ProfileEditSaveWithAvatar
  Future<void> profileEditSaveWithAvatar(
      {required Emitter emit,
      required UserEntity userEntity,
      required String imageFilePath}) async {
    emit(ProfileEditLoadingState());
    try {
      final bool isSuccess = await settingsFunctions.saveWithAvatar(
          currentUser: currentUser,
          userEntity: userEntity,
          imageFilePath: imageFilePath);
      if (isSuccess) {
        settingsFunctions.returnToHomeScreen();
      }
    } on FirebaseException catch (error) {
      emit(ProfileEditErrorState(error.message ?? defaultErrorMessage));
    }
  }

  ProfileEditBloc(this.currentUser) : super(ProfileEditInitial()) {
    on<ProfileEditEvent>((event, emit) async {
      if (event is ProfileEditStart) {
        profileEditStart(emit: emit);
      } else if (event is ProfileEditSetAvatar) {
        await profileEditSetAvatar(emit: emit);
      } else if (event is ProfileEditSaveWithoutAvatar) {
        await profileEditSaveWithoutAvatar(
            emit: emit, userEntity: event.userEntity);
      } else if (event is ProfileEditSaveWithAvatar) {
        await profileEditSaveWithAvatar(
            emit: emit,
            userEntity: event.userEntity,
            imageFilePath: event.newAvatarPath);
      }
    });
  }
}
