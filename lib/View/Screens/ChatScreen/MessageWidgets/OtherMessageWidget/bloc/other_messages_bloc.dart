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

  // This function is called whenever the event is OtherMessagesStart
  Future<void> otherMessagesStart(
      {required MessageEntity messageEntity, required Emitter emit}) async {
    if (messageEntity.needUpload) {
      emit(MessageFileLoadingState());
      try {
        await messagesFunctions.uploadFileMessage(
            otherMessagesBloc: this, messageEntity: messageEntity);
      } catch (e) {
        emit(MessageFileUploadErrorState());
      }
    } else {
      final bool isFileDownloaded = await messagesFunctions.isFileDownloaded(
        messageId: messageEntity.id,
      );
      if (isFileDownloaded) {
        emit(MessageFileReadyState());
      } else {
        emit(MessagesPervirewState());
      }
    }
  }

  // This function is called whenever the event is OtherMessagesDownloadFile
  Future<void> otherMessagesDownloadFile(
      {required MessageEntity messageEntity, required Emitter emit}) async {
    emit(MessageFileLoadingState());
    await messagesFunctions.downloadFile(
        messageEntity: messageEntity, otherMessagesBloc: this);
  }

  // This function is called whenever the event is OtherMessagesFileCompleted
  void otherMessagesFileCompleted(Emitter emit) {
    emit(MessageFileReadyState());
  }

  // This function is called whenever the event is OtherMessagesOpenFile
  Future<void> otherMessagesOpenFile(
      {required MessageEntity messageEntity, required Emitter emit}) async {
    await messagesFunctions.openFileMessage(
        messageEntity: messageEntity, otherMessagesBloc: this);
  }

  // This function is called whenever the event is OtherMessagesCancelDownloading
  void otherMessagesCancelDownloading(
      {required MessageEntity messageEntity, required Emitter emit}) {
    messagesFunctions.cancelDownload(messageEntity: messageEntity);
    emit(MessagesPervirewState());
  }

  // This function is called whenever the event is OtherMessagesCancelUploading
  void otherMessagesCancelUploading(
      {required MessageEntity messageEntity, required Emitter emit}) {
    messagesFunctions.cancelUpload(messageEntity: messageEntity);
  }

  // This function is called whenever the event is OtherMessagesDeleteErroredFile
  void otherMessagesDeleteErroredFile(
      {required MessageEntity messageEntity, required Emitter emit}) {
    messagesFunctions.deleteErroredMessage(messageEntity: messageEntity);
  }

  // This function is called whenever the event is OtherMessagesDownloadingStatus
  void otherMessagesDownloadingStatus(
      {required Emitter emit, required OperationProgress operationProgress}) {
    emit(MessageFileDownloadingState(operationProgress));
  }

  // This function is called whenever the event is OtherMessagesUploadingStatus
  void otherMessagesUploadingStatus(
      {required Emitter emit, required OperationProgress operationProgress}) {
    emit(MessageFileUploadingStatusState(operationProgress));
  }

  // This function is called whenever the event is OtherMessagesDownloadError
  void otherMessagesDownloadError(Emitter emit) {
    emit(MessageFileDownloadErrorState());
  }

  // This function is called whenever the event is OtherMessagesUploadError
  void otherMessagesUploadError(Emitter emit) {
    emit(MessageFileUploadErrorState());
  }

  // This function is called whenever the event is OtherMessagesLoading
  void otherMessagesLoading(Emitter emit) {
    emit(MessageFileLoadingState());
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
      } else if (event is OtherMessagesCancelUploading) {
        otherMessagesCancelUploading(
          messageEntity: event.messageEntity,
          emit: emit,
        );
      } else if (event is OtherMessagesDeleteErroredFile) {
        otherMessagesDeleteErroredFile(
          messageEntity: event.messageEntity,
          emit: emit,
        );
      } else if (event is OtherMessagesLoading) {
        otherMessagesLoading(emit);
      }
    });
  }
}
