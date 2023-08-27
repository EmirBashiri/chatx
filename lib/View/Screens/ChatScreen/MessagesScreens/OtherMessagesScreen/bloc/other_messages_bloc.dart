import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/duplicate_entities.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/messages_funtions.dart';
import 'package:get/get.dart';

part 'other_messages_event.dart';
part 'other_messages_state.dart';

class OtherMessagesBloc extends Bloc<OtherMessagesEvent, OtherMessagesState> {
  final DependencyController dependencyController = Get.find();
  late final MessagesFunctions messagesFunctions =
      dependencyController.appFunctions.messagesFunctions;

  // This function called whenever event is OtherMessagesStart
  Future<void> otherMessagesStart(
      {required MessageEntity messageEntity, required Emitter emit}) async {
    final bool isFileDownloaded =
        await messagesFunctions.isMessageFileDownloaded(
      messageUrl: messageEntity.message,
    );
    if (isFileDownloaded) {
      emit(MessageFileReadyScreen(
          messageEntity: messageEntity, messagesFunctions: messagesFunctions));
    } else {
      emit(MessagesPervirewScreen(
          messageEntity: messageEntity, messagesFunctions: messagesFunctions));
    }
  }

  // This function called whenever event is OtherMessagesDownloadFile
  Future<void> otherMessagesDownloadFile(
      {required MessageEntity messageEntity, required Emitter emit}) async {
    emit(MessageFileLoadingScreen(
        messageEntity: messageEntity, messagesFunctions: messagesFunctions));
    await messagesFunctions.downloadFile(
        messageEntity: messageEntity, otherMessagesBloc: this);
  }

  // This function called whenever event is OtherMessagesFileCompleted
  Future<void> otherMessagesFileCompleted(
      {required MessageEntity messageEntity, required Emitter emit}) async {
    emit(MessageFileReadyScreen(
      messagesFunctions: messagesFunctions,
      messageEntity: messageEntity,
    ));
  }

  // This function called whenever event is OtherMessagesOpenFile
  Future<void> otherMessagesOpenFile(
      {required MessageEntity messageEntity, required Emitter emit}) async {
    await messagesFunctions.openFileMessage(
        messageEntity: messageEntity, otherMessagesBloc: this);
  }

  // This function called whenever event is OtherMessagesCancelDownloading
  Future<void> otherMessagesCancelDownloading(
      {required MessageEntity messageEntity, required Emitter emit}) async {
    messagesFunctions.cancelDownload(messageEntity: messageEntity);
    emit(MessagesPervirewScreen(
        messageEntity: messageEntity, messagesFunctions: messagesFunctions));
  }

  // This function called whenever event is OtherMessagesDownloadStatus
  void otherMessagesDownloadStatus(
      {required MessageEntity messageEntity,
      required Emitter emit,
      required DownloadProgress downloadProgress}) {
    emit(MessageFileDownloadingScreen(
      messageEntity: messageEntity,
      messagesFunctions: messagesFunctions,
      downloadProgress: downloadProgress,
    ));
  }

  // This function called whenever event is OtherMessagesDownloadError
  void otherMessagesDownloadError(
      {required MessageEntity messageEntity, required Emitter emit}) {
    emit(MessageFileErrorScreen(
      messageEntity: messageEntity,
      messagesFunctions: messagesFunctions,
    ));
  }

  OtherMessagesBloc() : super(OtherMessagesInitial()) {
    on<OtherMessagesEvent>((event, emit) async {
      if (event is OtherMessagesStart) {
        await otherMessagesStart(
          messageEntity: event.messageEntity,
          emit: emit,
        );
      } else if (event is OtherMessagesDownloadFile) {
        await otherMessagesDownloadFile(
          messageEntity: event.messageEntity,
          emit: emit,
        );
      } else if (event is OtherMessagesDownloadStatus) {
        otherMessagesDownloadStatus(
          messageEntity: event.messageEntity,
          emit: emit,
          downloadProgress: event.downloadProgress,
        );
      } else if (event is OtherMessagesDownloadError) {
        otherMessagesDownloadError(
          messageEntity: event.messageEntity,
          emit: emit,
        );
      } else if (event is OtherMessagesFileCompleted) {
        await otherMessagesFileCompleted(
          messageEntity: event.messageEntity,
          emit: emit,
        );
      } else if (event is OtherMessagesOpenFile) {
        await otherMessagesOpenFile(
          messageEntity: event.messageEntity,
          emit: emit,
        );
      } else if (event is OtherMessagesCancelDownloading) {
        await otherMessagesCancelDownloading(
          messageEntity: event.messageEntity,
          emit: emit,
        );
      }
    });
  }
}
