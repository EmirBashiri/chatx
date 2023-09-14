part of 'chat_bloc_bloc.dart';

@immutable
sealed class ChatBlocEvent {}

// This event called whenever chat screen setting up
class ChatStart extends ChatBlocEvent {}

// This event called whenever chat stream receives an event
class ChatUpdate extends ChatBlocEvent {
  final List<MessageEntity> messagesList;

  ChatUpdate(this.messagesList);
}

// This event called whenever chat stream receives an error
class ChatError extends ChatBlocEvent {
  final dynamic error;

  ChatError(this.error);
}
