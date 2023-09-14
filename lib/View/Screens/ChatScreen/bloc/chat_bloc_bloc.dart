import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/chat_function.dart';
import 'package:get/get.dart';

part 'chat_bloc_event.dart';
part 'chat_bloc_state.dart';

class ChatBloc extends Bloc<ChatBlocEvent, ChatBlocState> {
  final RoomIdRequirements roomIdRequirements;
  final ChatFunctions chatFunctions =
      Get.find<DependencyController>().appFunctions.chatFunctions;

  // This function called whenever event is ChatStart
  void chatStart({required Emitter emit}) {
    emit(ChatLoadingScreen());
    chatFunctions.getMessage(
        roomIdRequirements: roomIdRequirements, chatBloc: this);
  }

  // This function called whenever event is ChatUpdate
  void chatUpdate(
      {required List<MessageEntity> messagesList, required Emitter emit}) {
    if (messagesList.isEmpty) {
      emit(EmptyChatScreen());
    } else {
      emit(ChatMainScreen(messagesList));
    }
  }

  // This function called whenever event is ChatError
  void chatError({required dynamic error, required Emitter emit}) {
    if (error is FirebaseException) {
      emit(ChatErrorScreen(error.message ?? defaultErrorMessage));
    } else {
      emit(ChatErrorScreen(defaultErrorMessage));
    }
  }

  ChatBloc(this.roomIdRequirements) : super(ChatBlocInitial()) {
    on<ChatBlocEvent>((event, emit) {
      if (event is ChatStart) {
        chatStart(emit: emit);
      } else if (event is ChatUpdate) {
        chatUpdate(messagesList: event.messagesList, emit: emit);
      } else if (event is ChatError) {
        chatError(error: event.error, emit: emit);
      }
    });
  }
}
