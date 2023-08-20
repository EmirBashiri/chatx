import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/chat_function.dart';
import 'package:get/get.dart';

part 'other_messages_event.dart';
part 'other_messages_state.dart';

class OtherMessagesBloc extends Bloc<OtherMessagesEvent, OtherMessagesState> {
  final DependencyController dependencyController = Get.find();
  late final ChatFunctions chatFunctions =
      dependencyController.appFunctions.chatFunctions;
  OtherMessagesBloc() : super(OtherMessagesInitial()) {
    on<OtherMessagesEvent>((event, emit) async {
      if (event is OtherMessagesStart) {
        final MessageEntity messageEntity = event.messageEntity;
        final bool isFileDownloaded =
            await chatFunctions.isMessageFileDownloaded(
          messageUrl: messageEntity.message,
        );
        if (isFileDownloaded) {
          emit(MessageFileReadyScreen(
              messageEntity: messageEntity, chatFunctions: chatFunctions));
        } else {
          emit(MessagesPervirewScreen(
              messageEntity: messageEntity, chatFunctions: chatFunctions));
        }
      } else if (event is OtherMessagesDownloadFile) {
        emit(MessageFileDownloadingScreen(
            messageEntity: event.messageEntity, chatFunctions: chatFunctions));
      } else if (event is OtherMessagesOpenFile) {
        // TODO implement this event
      }
    });
  }
}
