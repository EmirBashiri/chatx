part of 'other_messages_bloc.dart';

@immutable
sealed class OtherMessagesState {}

final class OtherMessagesInitial extends OtherMessagesState {}

// This state is launched whenever other messages screen setting up
class MessagesPervirewScreen extends OtherMessagesState {}

// This state is launched whenever messages file loading
class MessageFileLoadingScreen extends OtherMessagesState {}

// This state is launched whenever the file is being dowloaded to display progress
class MessageFileDownloadingScreen extends OtherMessagesState {
  final OperationProgress operationProgress;
  MessageFileDownloadingScreen(this.operationProgress);
}

// This state is launched whenever the file is being uploaded to display progress
class MessageFileUploadingStatusScreen extends OtherMessagesState {
  final OperationProgress operationProgress;
  MessageFileUploadingStatusScreen(this.operationProgress);
}

// This state is launched whenever messages file being downloaded and an error detected
class MessageFileDownloadErrorScreen extends OtherMessagesState {}

// This state is launched whenever messages file being uploaded and an error detected
class MessageFileUploadErrorScreen extends OtherMessagesState {}

// This state is launched whenever messages file is ready
class MessageFileReadyScreen extends OtherMessagesState {}
