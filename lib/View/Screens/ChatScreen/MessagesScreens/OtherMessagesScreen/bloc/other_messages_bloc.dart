import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/messages_funtions.dart';
import 'package:get/get.dart';

part 'other_messages_event.dart';
part 'other_messages_state.dart';

class OtherMessagesBloc extends Bloc<OtherMessagesEvent, OtherMessagesState> {
  final DependencyController dependencyController = Get.find();
  late final MessagesFunctions messagesFunctions =
      dependencyController.appFunctions.messagesFunctions;
  OtherMessagesBloc() : super(OtherMessagesInitial()) {
    on<OtherMessagesEvent>((event, emit) async {
      if (event is OtherMessagesStart) {
        final MessageEntity messageEntity = event.messageEntity;
        final bool isFileDownloaded =
            await messagesFunctions.isMessageFileDownloaded(
          messageUrl: messageEntity.message,
        );
        if (isFileDownloaded) {
          emit(MessageFileReadyScreen(
              messageEntity: messageEntity,
              messagesFunctions: messagesFunctions));
        } else {
          emit(MessagesPervirewScreen(
              messageEntity: messageEntity,
              messagesFunctions: messagesFunctions));
        }
      } else if (event is OtherMessagesDownloadFile) {
        emit(MessageFileDownloadingScreen(
            messageEntity: event.messageEntity,
            messagesFunctions: messagesFunctions));
      } else if (event is OtherMessagesFileCompleted) {
        emit(
          MessageFileReadyScreen(
            messagesFunctions: messagesFunctions,
            messageEntity: event.messageEntity,
          ),
        );
      } else if (event is OtherMessagesOpenFile) {
        await messagesFunctions.openFile(
            messageEntity: event.messageEntity, emitter: emit);
      }
    });
  }
}
