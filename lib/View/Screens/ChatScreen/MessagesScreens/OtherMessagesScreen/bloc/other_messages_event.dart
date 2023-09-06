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

// This event is called whenever file was downloading and user tap to cancel it
class OtherMessagesCancelDownloading extends OtherMessagesEvent {
  final MessageEntity messageEntity;

  OtherMessagesCancelDownloading(this.messageEntity);
}    

// This event is called whenever file is downloading to fech operation progress
class OtherMessagesDownloadingStatus extends OtherMessagesEvent {
  final OperationProgress operationProgress;

  OtherMessagesDownloadingStatus(this.operationProgress);
}

// This event is called whenever file is uploading to fech operation progress
class OtherMessagesUploadingStatus extends OtherMessagesEvent {
  final OperationProgress operationProgress;

  OtherMessagesUploadingStatus(this.operationProgress);
}

// This event is called whenever file was downloading and an error detected
class OtherMessagesDownloadError extends OtherMessagesEvent {}

// This event is called whenever operation needs loading
class OtherMessagesLoading extends OtherMessagesEvent {}

// This event is called whenever file was uploading and an error detected
class OtherMessagesUploadError extends OtherMessagesEvent {}
