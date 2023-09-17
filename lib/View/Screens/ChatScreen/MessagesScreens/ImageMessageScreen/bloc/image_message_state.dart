part of 'image_message_bloc.dart';

@immutable
sealed class ImageMessageState {}

final class ImageMessageInitial extends ImageMessageState {}

// This state is launched whenever the image message is ready to download
class ImageMessagePerviewScreen extends ImageMessageState {}

// This state is launched whenever the image operation needs loading
class ImageMessageLoadingScreen extends ImageMessageState {}

// This state is launched whenever the image being downloaded and sended to show operation progess
class ImageMessageDownloadProgressScreen extends ImageMessageState {
  final OperationProgress operationProgress;
  ImageMessageDownloadProgressScreen(this.operationProgress);
}

// This state is launched whenever the image being uploaded and sended to show operation progess
class ImageMessageUoloadProgressScreen extends ImageMessageState {
  final OperationProgress operationProgress;
  final File? imageFile;
  ImageMessageUoloadProgressScreen(
      {required this.operationProgress, required this.imageFile});
}

// This state is launched whenever the image operation is completed
class ImageMessageReadyScreen extends ImageMessageState {
  final File imageFile;

  ImageMessageReadyScreen(this.imageFile);
}

// This state is launched whenever an errer detected in the image uploading process
class ImageMessageUploadErrorScreen extends ImageMessageState {
  final File? imageFile;

  ImageMessageUploadErrorScreen({this.imageFile});
}

// This state is launched whenever an errer detected in the image downloaded process
class ImageMessageDownloadErrorScreen extends ImageMessageState {}
