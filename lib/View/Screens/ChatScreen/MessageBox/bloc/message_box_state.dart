part of 'message_box_bloc.dart';

@immutable
sealed class MessageBoxState {}

final class MessageBoxInitial extends MessageBoxState {}

// This box lanuch whenever message is text
class MessageTextBox extends MessageBoxState {
  final MessageEntity messageEntity;

  MessageTextBox(this.messageEntity);
}

// This box lanuch whenever message is image
class MessageImageBox extends MessageBoxState {
  final MessageEntity messageEntity;

  MessageImageBox(this.messageEntity);
}

// This box lanuch whenever message is file
class MessageFileBox extends MessageBoxState {
  final MessageEntity messageEntity;

  MessageFileBox(this.messageEntity);
}

// This box lanuch whenever message is downloaded file
class MessageDownloadedFileBox extends MessageBoxState {
  final MessageEntity messageEntity;

  MessageDownloadedFileBox(this.messageEntity);
}

// This box lanuch whenever message is file and file are downloading
class MessageLoadingFileBox extends MessageBoxState {
  final MessageEntity messageEntity;

  MessageLoadingFileBox(this.messageEntity);
}
