part of 'other_messages_bloc.dart';

@immutable
sealed class OtherMessagesState {}

final class OtherMessagesInitial extends OtherMessagesState {}

// This state is launched whenever other messages screen setting up
class MessagesPervirewScreen extends OtherMessagesState {
  final MessageEntity messageEntity;
  final MessagesFunctions messagesFunctions;
  MessagesPervirewScreen(
      {required this.messageEntity, required this.messagesFunctions});
}

// This state is launched whenever messages file downloading
class MessageFileDownloadingScreen extends OtherMessagesState {
  final MessageEntity messageEntity;
  final MessagesFunctions messagesFunctions;
  MessageFileDownloadingScreen({
    required this.messageEntity,
    required this.messagesFunctions,
  });
}

// This state is launched whenever messages file downloaded
class MessageFileReadyScreen extends OtherMessagesState {
  final MessageEntity messageEntity;
  final MessagesFunctions messagesFunctions;
  MessageFileReadyScreen({
    required this.messageEntity,
    required this.messagesFunctions,
  });
}
