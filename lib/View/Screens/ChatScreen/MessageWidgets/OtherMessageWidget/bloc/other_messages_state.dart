part of 'other_messages_bloc.dart';

@immutable
sealed class OtherMessagesState {}

final class OtherMessagesInitial extends OtherMessagesState {}

// This state is launched whenever other messages screen is setting up
class MessagesPervirewState extends OtherMessagesState {}

// This state is launched whenever the messages file is loading
class MessageFileLoadingState extends OtherMessagesState {}

// This state is launched whenever the file is being downloaded to display the progress
class MessageFileDownloadingState extends OtherMessagesState {
  final OperationProgress operationProgress;
  MessageFileDownloadingState(this.operationProgress);
}

// This state is launched whenever the file is being uploaded to display the progress
class MessageFileUploadingStatusState extends OtherMessagesState {
  final OperationProgress operationProgress;
  MessageFileUploadingStatusState(this.operationProgress);
}

// This state is launched whenever the messages file is being downloaded and an error detected
class MessageFileDownloadErrorState extends OtherMessagesState {}

// This state is launched whenever the messages file is being uploaded and an error detected
class MessageFileUploadErrorState extends OtherMessagesState {}

// This state is launched whenever the messages file is ready
class MessageFileReadyState extends OtherMessagesState {}
