part of 'other_messages_bloc.dart';

@immutable
sealed class OtherMessagesEvent {}

// This event is called whenever other messages screen setting up
class OtherMessagesStart extends OtherMessagesEvent {
  final MessageEntity messageEntity;

  OtherMessagesStart(this.messageEntity);
}

// This event is called whenever file not downloaded and user tap to download it
class OtherMessagesDownloadFile extends OtherMessagesEvent {
  final MessageEntity messageEntity;

  OtherMessagesDownloadFile(this.messageEntity);
}

// This event is called whenever file download completed
class OtherMessagesFileCompleted extends OtherMessagesEvent {}

// This event is called whenever file downloaded and user tap to open it
class OtherMessagesOpenFile extends OtherMessagesEvent {
  final MessageEntity messageEntity;

  OtherMessagesOpenFile(this.messageEntity);
}

// This event is called whenever user want cancel file downloading
class OtherMessagesCancelDownloading extends OtherMessagesEvent {
  final MessageEntity messageEntity;

  OtherMessagesCancelDownloading(this.messageEntity);
}

// This event called whenever user want cancel file  uploading
class OtherMessagesCancelUploading extends OtherMessagesEvent {
  final MessageEntity messageEntity;

  OtherMessagesCancelUploading(this.messageEntity);
}

// This event called whenever user want delete errored message
class OtherMessagesDeleteErroredFile extends OtherMessagesEvent {
  final MessageEntity messageEntity;

  OtherMessagesDeleteErroredFile(this.messageEntity);
}

// This event is called whenever the file being downloaded to show operation progress
class OtherMessagesDownloadingStatus extends OtherMessagesEvent {
  final OperationProgress operationProgress;

  OtherMessagesDownloadingStatus(this.operationProgress);
}

// This event is called whenever the file being uploaded to show operation progress
class OtherMessagesUploadingStatus extends OtherMessagesEvent {
  final OperationProgress operationProgress;

  OtherMessagesUploadingStatus(this.operationProgress);
}

// This event is called whenever an error detected in downloading operation
class OtherMessagesDownloadError extends OtherMessagesEvent {}

// This event is called whenever operation needs loading
class OtherMessagesLoading extends OtherMessagesEvent {}

// This event is called whenever an error detected in uploading operation
class OtherMessagesUploadError extends OtherMessagesEvent {}
