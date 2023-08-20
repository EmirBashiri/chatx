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
  ChatBloc() : super(ChatInitial()) {
    on<ChatEvent>((event, emit) async {
      try {
        if (event is ChatStart) {
          emit(
            ChatLoadingScreen(),
          );
          chatFunctions.getMessage(
            roomIdRequirements: event.roomIdRequirements,
            chatBloc: this,
          );
        } else if (event is ChatUpdate) {
          final List<MessageEntity> messagesList = event.messagesList;
          if (messagesList.isNotEmpty) {
            emit(ChatMainScreen(messagesList));
          } else {
            emit(ChatEmptyScreen());
          }
        }
      } on FirebaseException catch (error) {
        emit(ChatErrorScreen(error.message ?? defaultErrorMessage));
      }
    });
  }
}
