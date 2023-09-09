part of 'image_message_bloc.dart';

@immutable
sealed class ImageMessageState {}

final class ImageMessageInitial extends ImageMessageState {}

// This state launched whenever image message ready to download
class ImageMessagePerviewScreen extends ImageMessageState {}

// This state launched whenever image operation need loading
class ImageMessageLoadingScreen extends ImageMessageState {}

// This state launched whenever the image being uploaded and sended to show operation progess
class ImageMessageDownloadProgressScreen extends ImageMessageState {
  final OperationProgress operationProgress;
  ImageMessageDownloadProgressScreen(this.operationProgress);
}

// This state launched whenever the image being uploaded and sended to show operation progess
class ImageMessageUoloadProgressScreen extends ImageMessageState {
  final OperationProgress operationProgress;
  final File? imageFile;
  ImageMessageUoloadProgressScreen(
      {required this.operationProgress, required this.imageFile});
}

// This state launched whenever image operation completed
class ImageMessageReadyScreen extends ImageMessageState {
  final File imageFile;

  ImageMessageReadyScreen(this.imageFile);
}

// This state launched whenever an errer detected in image opration
class ImageMessageUploadErrorScreen extends ImageMessageState {
  final File? imageFile;

  ImageMessageUploadErrorScreen({this.imageFile});
}

// This state launched whenever an errer detected in image opration
class ImageMessageDownloadErrorScreen extends ImageMessageState {}
