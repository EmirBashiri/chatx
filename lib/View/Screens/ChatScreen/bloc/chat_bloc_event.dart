part of 'chat_bloc_bloc.dart';

@immutable
sealed class ChatBlocEvent {}

// This event is called whenever the chat screen is setting up
class ChatStart extends ChatBlocEvent {}

// This event is called whenever the chat stream receives an event
class ChatUpdate extends ChatBlocEvent {
  final List<MessageEntity> messagesList;

  ChatUpdate(this.messagesList);
}

// This event is called whenever the chat stream receives an error
class ChatError extends ChatBlocEvent {
  final dynamic error;

  ChatError(this.error);
}
