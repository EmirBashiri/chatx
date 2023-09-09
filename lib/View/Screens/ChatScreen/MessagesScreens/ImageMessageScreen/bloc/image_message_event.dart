part of 'image_message_bloc.dart';

@immutable
sealed class ImageMessageEvent {}

// This event called whenever image message widget setting up
class ImageMessageStart extends ImageMessageEvent {
  final MessageEntity messageEntity;

  ImageMessageStart(this.messageEntity);
}

// This event called whenever user want download image
class ImageMessageStartDownload extends ImageMessageEvent {
  final MessageEntity messageEntity;

  ImageMessageStartDownload(this.messageEntity);
}

// This event called whenever the image being uploaded and sended to show operation progess
class ImageMessageDownloadProgress extends ImageMessageEvent {
  final OperationProgress operationProgress;

  ImageMessageDownloadProgress(this.operationProgress);
}

// This event called whenever the image being uploaded and sended to show operation progess
class ImageMessageUploadProgress extends ImageMessageEvent {
  final OperationProgress operationProgress;
  final File? imageFile;

  ImageMessageUploadProgress({required this.operationProgress, this.imageFile});
}

// This event called whenever the image operatin need loading
class ImageMessageLoading extends ImageMessageEvent {}

// This event called whenever image operation completed
class ImageMessageOperationComplete extends ImageMessageEvent {
  final File imageFile;

  ImageMessageOperationComplete(this.imageFile);
}

// This event called whenever an errer detected in image uploading time
class ImageMessageUploadError extends ImageMessageEvent {
  final File? imageFile;

  ImageMessageUploadError({this.imageFile});
}

// This event called whenever an errer detected in image downloading time
class ImageMessageDownloadError extends ImageMessageEvent {}
