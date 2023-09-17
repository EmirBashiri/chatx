part of 'image_message_bloc.dart';

@immutable
sealed class ImageMessageEvent {}

// This event is called whenever the image message widget is setting up
class ImageMessageStart extends ImageMessageEvent {
  final MessageEntity messageEntity;

  ImageMessageStart(this.messageEntity);
}

// This event is called whenever the user taps to download image
class ImageMessageStartDownload extends ImageMessageEvent {
  final MessageEntity messageEntity;

  ImageMessageStartDownload(this.messageEntity);
}

// This event is called whenever the user taps to cancel image downloading
class ImageMessageCancelDownload extends ImageMessageEvent {
  final MessageEntity messageEntity;

  ImageMessageCancelDownload(this.messageEntity);
}

// This event is called whenever the user taps to cancel image uploading
class ImageMessageCancelUpload extends ImageMessageEvent {
  final MessageEntity messageEntity;

  ImageMessageCancelUpload(this.messageEntity);
}

// This event is called whenever the user taps to delete errored message
class ImageMessageDeleteErroredImage extends ImageMessageEvent {
  final MessageEntity messageEntity;

  ImageMessageDeleteErroredImage(this.messageEntity);
}

// This event is called whenever the image being downloaded to show operation progess
class ImageMessageDownloadProgress extends ImageMessageEvent {
  final OperationProgress operationProgress;

  ImageMessageDownloadProgress(this.operationProgress);
}

// This event is called whenever the image being uploaded and sended to show operation progess
class ImageMessageUploadProgress extends ImageMessageEvent {
  final OperationProgress operationProgress;
  final File? imageFile;

  ImageMessageUploadProgress({required this.operationProgress, this.imageFile});
}

// This event is called whenever the image operation needs loading
class ImageMessageLoading extends ImageMessageEvent {}

// This event is called whenever the image operation is completed
class ImageMessageOperationComplete extends ImageMessageEvent {
  final File imageFile;

  ImageMessageOperationComplete(this.imageFile);
}

// This event is called whenever an error detected in the image uploading process
class ImageMessageUploadError extends ImageMessageEvent {
  final File? imageFile;

  ImageMessageUploadError({this.imageFile});
}

// This event is called whenever an errer detected in the image downloading process
class ImageMessageDownloadError extends ImageMessageEvent {}
