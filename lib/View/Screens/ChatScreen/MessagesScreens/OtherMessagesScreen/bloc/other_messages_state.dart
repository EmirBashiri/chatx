part of 'other_messages_bloc.dart';

@immutable
sealed class OtherMessagesState {}

final class OtherMessagesInitial extends OtherMessagesState {}

// This state is launched whenever other messages screen is setting up
class MessagesPervirewScreen extends OtherMessagesState {}

// This state is launched whenever the messages file is loading
class MessageFileLoadingScreen extends OtherMessagesState {}

// This state is launched whenever the file is being downloaded to display the progress
class MessageFileDownloadingScreen extends OtherMessagesState {
  final OperationProgress operationProgress;
  MessageFileDownloadingScreen(this.operationProgress);
}

// This state is launched whenever the file is being uploaded to display the progress
class MessageFileUploadingStatusScreen extends OtherMessagesState {
  final OperationProgress operationProgress;
  MessageFileUploadingStatusScreen(this.operationProgress);
}

// This state is launched whenever the messages file is being downloaded and an error detected
class MessageFileDownloadErrorScreen extends OtherMessagesState {}

// This state is launched whenever the messages file is being uploaded and an error detected
class MessageFileUploadErrorScreen extends OtherMessagesState {}

// This state is launched whenever the messages file is ready
class MessageFileReadyScreen extends OtherMessagesState {}
