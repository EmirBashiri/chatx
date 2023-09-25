part of 'image_message_bloc.dart';

@immutable
sealed class ImageMessageState {}

final class ImageMessageInitial extends ImageMessageState {}

// This state is launched whenever the image message is ready to download
class ImageMessagePerviewState extends ImageMessageState {}

// This state is launched whenever the image operation needs loading
class ImageMessageLoadingState extends ImageMessageState {}

// This state is launched whenever the image being downloaded and sended to show operation progess
class ImageMessageDownloadProgressState extends ImageMessageState {
  final OperationProgress operationProgress;
  ImageMessageDownloadProgressState(this.operationProgress);
}

// This state is launched whenever the image being uploaded and sended to show operation progess
class ImageMessageUoloadProgressState extends ImageMessageState {
  final OperationProgress operationProgress;
  final File? imageFile;
  ImageMessageUoloadProgressState(
      {required this.operationProgress, required this.imageFile});
}

// This state is launched whenever the image operation is completed
class ImageMessageReadyState extends ImageMessageState {
  final File imageFile;

  ImageMessageReadyState(this.imageFile);
}

// This state is launched whenever an errer detected in the image uploading process
class ImageMessageUploadErrorState extends ImageMessageState {
  final File? imageFile;

  ImageMessageUploadErrorState({this.imageFile});
}

// This state is launched whenever an errer detected in the image downloaded process
class ImageMessageDownloadErrorState extends ImageMessageState {}
