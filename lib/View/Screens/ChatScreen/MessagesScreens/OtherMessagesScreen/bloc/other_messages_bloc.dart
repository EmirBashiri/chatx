import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/duplicate_entities.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/chat_function.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/messages_funtions.dart';
import 'package:get/get.dart';

part 'other_messages_event.dart';
part 'other_messages_state.dart';

class OtherMessagesBloc extends Bloc<OtherMessagesEvent, OtherMessagesState> {
  final DependencyController dependencyController = Get.find();
  late final MessagesFunctions messagesFunctions =
      dependencyController.appFunctions.messagesFunctions;
  late final ChatFunctions chatFunctions =
      dependencyController.appFunctions.chatFunctions;

  // This function called whenever event is OtherMessagesStart
  Future<void> otherMessagesStart(
      {required MessageEntity messageEntity, required Emitter emit}) async {
    if (messageEntity.isUploading) {
      emit(MessageFileLoadingScreen());
     try {
        await messagesFunctions.uploadFileMessage(
          otherMessagesBloc: this, messageEntity: messageEntity);
     } catch (e) {
       emit(MessageFileUploadErrorScreen());
     }
    } else {
      final bool isFileDownloaded =
          await messagesFunctions.isMessageFileDownloaded(
        messageUrl: messageEntity.message,
      );
      if (isFileDownloaded) {
        emit(MessageFileReadyScreen());
      } else {
        emit(MessagesPervirewScreen());
      }
    }
  }

  // This function called whenever event is OtherMessagesDownloadFile
  Future<void> otherMessagesDownloadFile(
      {required MessageEntity messageEntity, required Emitter emit}) async {
    emit(MessageFileLoadingScreen());
    await messagesFunctions.downloadFile(
        messageEntity: messageEntity, otherMessagesBloc: this);
  }

  // This function called whenever event is OtherMessagesFileCompleted
  void otherMessagesFileCompleted(Emitter emit) {
    emit(MessageFileReadyScreen());
  }

  // This function called whenever event is OtherMessagesOpenFile
  Future<void> otherMessagesOpenFile(
      {required MessageEntity messageEntity, required Emitter emit}) async {
    await messagesFunctions.openFileMessage(
        messageEntity: messageEntity, otherMessagesBloc: this);
  }

  // This function called whenever event is OtherMessagesCancelDownloading
  void otherMessagesCancelDownloading(
      {required MessageEntity messageEntity, required Emitter emit}) {
    messagesFunctions.cancelDownload(messageEntity: messageEntity);
    emit(MessagesPervirewScreen());
  }

  // This function called whenever event is OtherMessagesDownloadingStatus
  void otherMessagesDownloadingStatus(
      {required Emitter emit, required OperationProgress operationProgress}) {
    emit(MessageFileDownloadingScreen(operationProgress));
  }

  // This function called whenever event is OtherMessagesUploadingStatus
  void otherMessagesUploadingStatus(
      {required Emitter emit, required OperationProgress operationProgress}) {
    emit(MessageFileUploadingStatusScreen(operationProgress));
  }

  // This function called whenever event is OtherMessagesDownloadError
  void otherMessagesDownloadError(Emitter emit) {
    emit(MessageFileDownloadErrorScreen());
  }

  // This function called whenever event is OtherMessagesUploadError
  void otherMessagesUploadError(Emitter emit) {
    emit(MessageFileUploadErrorScreen());
  }

  // This function called whenever event is OtherMessagesLoading
  void otherMessagesLoading(Emitter emit) {
    emit(MessageFileLoadingScreen());
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
      } else if (event is OtherMessagesDownloadingStatus) {
        otherMessagesDownloadingStatus(
          emit: emit,
          operationProgress: event.operationProgress,
        );
      } else if (event is OtherMessagesUploadingStatus) {
        otherMessagesUploadingStatus(
          emit: emit,
          operationProgress: event.operationProgress,
        );
      } else if (event is OtherMessagesDownloadError) {
        otherMessagesDownloadError(emit);
      } else if (event is OtherMessagesUploadError) {
        otherMessagesUploadError(emit);
      } else if (event is OtherMessagesFileCompleted) {
        otherMessagesFileCompleted(emit);
      } else if (event is OtherMessagesOpenFile) {
        await otherMessagesOpenFile(
          messageEntity: event.messageEntity,
          emit: emit,
        );
      } else if (event is OtherMessagesCancelDownloading) {
        otherMessagesCancelDownloading(
          messageEntity: event.messageEntity,
          emit: emit,
        );
      } else if (event is OtherMessagesLoading) {
        otherMessagesLoading(emit);
      }
    });
  }
}
