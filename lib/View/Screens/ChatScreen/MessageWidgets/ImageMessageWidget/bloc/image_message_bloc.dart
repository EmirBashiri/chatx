import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/duplicate_entities.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/messages_funtions.dart';
import 'package:get/get.dart';

part 'image_message_event.dart';
part 'image_message_state.dart';

class ImageMessageBloc extends Bloc<ImageMessageEvent, ImageMessageState> {
  final MessagesFunctions messagesFunctions =
      Get.find<DependencyController>().appFunctions.messagesFunctions;

  // This function is called whenever the event is ImageMessageStart
  Future<void> imageMessageStart({
    required MessageEntity messageEntity,
    required Emitter emit,
  }) async {
    emit(ImageMessageLoadingState());
    if (messageEntity.needUpload) {
      try {
        await messagesFunctions.uploadImageMessage(
            imageMessageBloc: this, messageEntity: messageEntity);
      } catch (e) {
        emit(ImageMessageUploadErrorState());
      }
    } else {
      final bool isFileDownloaded = await messagesFunctions.isFileDownloaded(
        messageId: messageEntity.id,
      );

      if (isFileDownloaded) {
        final imageFile = await messagesFunctions.getFileFromCache(
            messageId: messageEntity.id);
        emit(ImageMessageReadyState(imageFile!));
      } else {
        emit(ImageMessagePerviewState());
      }
    }
  }

  // This function is called whenever the event is ImageMessageStartDownload
  Future<void> imageMessageStartDownload({
    required MessageEntity messageEntity,
    required Emitter emit,
  }) async {
    emit(ImageMessageLoadingState());
    await messagesFunctions.downloadImageFile(
        messageEntity: messageEntity, imageMessageBloc: this);
  }

  // This function is called whenever the event is ImageMessageCancelDownload
  void imageMessageCancelDownload({
    required MessageEntity messageEntity,
    required Emitter emit,
  }) {
    messagesFunctions.cancelDownload(messageEntity: messageEntity);
  }

  // This function is called whenever the event is ImageMessageCancelUpload
  void imageMessageCancelUpload({
    required MessageEntity messageEntity,
    required Emitter emit,
  }) {
    messagesFunctions.cancelUpload(messageEntity: messageEntity);
  }

  // This function is called whenever the event is ImageMessageDeleteErroredImage
  void imageMessageDeleteErroredImage({
    required MessageEntity messageEntity,
    required Emitter emit,
  }) {
    messagesFunctions.deleteErroredMessage(messageEntity: messageEntity);
  }

  // This function is called whenever the event is ImageMessageUploadProgress
  void imageMessageUploadProgress(
      {required OperationProgress operationProgress,
      File? imageFile,
      required Emitter emit}) {
    emit(ImageMessageUoloadProgressState(
        operationProgress: operationProgress, imageFile: imageFile));
  }

  // This function is called whenever the event is ImageMessageDownloadProgress
  void imageMessageDownloadProgress(
      {required OperationProgress operationProgress, required Emitter emit}) {
    emit(ImageMessageDownloadProgressState(operationProgress));
  }

  // This function is called whenever the event is ImageMessageLoading
  void imageMessageLoading({required Emitter emit}) {
    emit(ImageMessageLoadingState());
  }

  // This function is called whenever the event is ImageMessageOperationComplete
  void imageMessageOperationComplete(
      {required File imageFile, required Emitter emit}) {
    emit(ImageMessageReadyState(imageFile));
  }

  // This function is called whenever the event is ImageMessageUploadError
  void imageMessageUploadError(
      {required File? imageFile, required Emitter emit}) {
    emit(ImageMessageUploadErrorState(imageFile: imageFile));
  }

  // This function is called whenever the event is ImageMessageDownloadError
  void imageMessageDownloadError({required Emitter emit}) {
    emit(ImageMessageDownloadErrorState());
  }

  ImageMessageBloc() : super(ImageMessageInitial()) {
    on<ImageMessageEvent>((event, emit) async {
      if (event is ImageMessageStart) {
        await imageMessageStart(messageEntity: event.messageEntity, emit: emit);
      } else if (event is ImageMessageStartDownload) {
        imageMessageStartDownload(
            messageEntity: event.messageEntity, emit: emit);
      } else if (event is ImageMessageCancelDownload) {
        imageMessageCancelDownload(
            messageEntity: event.messageEntity, emit: emit);
      } else if (event is ImageMessageCancelUpload) {
        imageMessageCancelUpload(
            messageEntity: event.messageEntity, emit: emit);
      } else if (event is ImageMessageDeleteErroredImage) {
        imageMessageDeleteErroredImage(
            messageEntity: event.messageEntity, emit: emit);
      } else if (event is ImageMessageUploadProgress) {
        imageMessageUploadProgress(
          operationProgress: event.operationProgress,
          imageFile: event.imageFile,
          emit: emit,
        );
      } else if (event is ImageMessageDownloadProgress) {
        imageMessageDownloadProgress(
          operationProgress: event.operationProgress,
          emit: emit,
        );
      } else if (event is ImageMessageLoading) {
        imageMessageLoading(emit: emit);
      } else if (event is ImageMessageOperationComplete) {
        imageMessageOperationComplete(imageFile: event.imageFile, emit: emit);
      } else if (event is ImageMessageUploadError) {
        imageMessageUploadError(imageFile: event.imageFile, emit: emit);
      } else if (event is ImageMessageDownloadError) {
        imageMessageDownloadError(emit: emit);
      }
    });
  }
}
