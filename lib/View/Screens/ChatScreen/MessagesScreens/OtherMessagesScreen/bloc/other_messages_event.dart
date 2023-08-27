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
class OtherMessagesFileCompleted extends OtherMessagesEvent {
  final MessageEntity messageEntity;

  OtherMessagesFileCompleted(this.messageEntity);
}

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

// This event is called whenever file was downloading
class OtherMessagesDownloadStatus extends OtherMessagesEvent {
  final MessageEntity messageEntity;
  final DownloadProgress downloadProgress;

  OtherMessagesDownloadStatus({
    required this.downloadProgress,
    required this.messageEntity,
  });
}

// This event is called whenever file was downloading and an error detected
class OtherMessagesDownloadError extends OtherMessagesEvent {
  final MessageEntity messageEntity;

  OtherMessagesDownloadError(this.messageEntity);
}
