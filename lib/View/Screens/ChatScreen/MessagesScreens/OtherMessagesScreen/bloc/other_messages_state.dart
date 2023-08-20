part of 'other_messages_bloc.dart';

@immutable
sealed class OtherMessagesState {}

final class OtherMessagesInitial extends OtherMessagesState {}

// This state is launched whenever other messages screen setting up
class MessagesPervirewScreen extends OtherMessagesState {
  final MessageEntity messageEntity;
  final ChatFunctions chatFunctions;
  MessagesPervirewScreen(
      {required this.messageEntity, required this.chatFunctions});
}

// This state is launched whenever messages file downloading
class MessageFileDownloadingScreen extends OtherMessagesState {
  final MessageEntity messageEntity;
  final ChatFunctions chatFunctions;
  MessageFileDownloadingScreen({
    required this.messageEntity,
    required this.chatFunctions,
  });
}

// This state is launched whenever messages file downloaded
class MessageFileReadyScreen extends OtherMessagesState {
  final MessageEntity messageEntity;
  final ChatFunctions chatFunctions;
  MessageFileReadyScreen({
    required this.messageEntity,
    required this.chatFunctions,
  });
}
