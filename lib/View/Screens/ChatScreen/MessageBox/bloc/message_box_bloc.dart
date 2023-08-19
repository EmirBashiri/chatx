import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/chat_function.dart';
import 'package:get/get.dart';

part 'message_box_event.dart';
part 'message_box_state.dart';

class MessageBoxBloc extends Bloc<MessageBoxEvent, MessageBoxState> {
  final DependencyController _dependencyController = Get.find();
  late final ChatFunctions chatFunctions =
      _dependencyController.appFunctions.chatFunctions;

  MessageBoxBloc() : super(MessageBoxInitial()) {
    on<MessageBoxEvent>((event, emit) {
      if (event is MessageBoxStart) {
        final MessageEntity messageEntity = event.messageEntity;
        switch (messageEntity.messageType) {
          case MessageType.txt:
            emit(MessageTextBox(messageEntity));
            break;
          case MessageType.image:
            emit(MessageImageBox(messageEntity));
            break;
          case MessageType.other:
            emit(MessageFileBox(messageEntity));
            break;
        }
      } else if (event is MessageDownloadFile) {
        emit(MessageLoadingFileBox(event.messageEntity));
      } else if (event is MessageOpenFile) {
        // TODO implement open file here
      }
    });
  }
}
