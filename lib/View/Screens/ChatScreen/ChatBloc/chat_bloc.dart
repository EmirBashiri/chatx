import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/chat_function.dart';
import 'package:get/get.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final DependencyController dependencyController = Get.find();
  late final ChatFunctions chatFunctions =
      dependencyController.appFunctions.chatFunctions;

  // This function called whenever event is ChatStart
  void chatStart({
    required ChatFunctions chatFunctions,
    required RoomIdRequirements roomIdRequirements,
    required Emitter emit,
  }) {
    emit(ChatLoadingScreen());
    chatFunctions.getMessage(
      roomIdRequirements: roomIdRequirements,
      chatBloc: this,
    );
  }

  // This function called whenever event is ChatUpdate
  void chatUpdate({
    required List<MessageEntity> messageList,
    required Emitter emit,
  }) {
    if (messageList.isNotEmpty) {
      emit(ChatMainScreen(messageList));
    } else {
      emit(ChatEmptyScreen());
    }
  }

  ChatBloc() : super(ChatInitial()) {
    on<ChatEvent>((event, emit) async {
      try {
        if (event is ChatStart) {
          chatStart(
            chatFunctions: chatFunctions,
            roomIdRequirements: event.roomIdRequirements,
            emit: emit,
          );
        } else if (event is ChatUpdate) {
          chatUpdate(messageList: event.messageList, emit: emit);
        }
      } on FirebaseException catch (error) {
        emit(ChatErrorScreen(error.message ?? defaultErrorMessage));
      }
    });
  }
}
