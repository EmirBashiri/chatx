part of 'chat_bloc_bloc.dart';

@immutable
sealed class ChatBlocState {}

final class ChatBlocInitial extends ChatBlocState {}

// This state launched whenever chat screen ready to use
class ChatMainScreen extends ChatBlocState {
  final List<MessageEntity> messagesList;

  ChatMainScreen(this.messagesList);
}

// This state launched whenever chat messages is empty
class EmptyChatScreen extends ChatBlocState {}

// This state launched whenever chat is being ready
class ChatLoadingScreen extends ChatBlocState {}

// This state launched whenever an error detected in chat process
class ChatErrorScreen extends ChatBlocState {
  final String errorMessage;

  ChatErrorScreen(this.errorMessage);
}
