part of 'chat_bloc_bloc.dart';

@immutable
sealed class ChatBlocState {}

final class ChatBlocInitial extends ChatBlocState {}

// This state is launched whenever the chat screen ready to use
class ChatMainScreen extends ChatBlocState {
  final List<MessageEntity> messagesList;

  ChatMainScreen(this.messagesList);
}

// This state is launched whenever chat messages are empty
class EmptyChatScreen extends ChatBlocState {}

// This state is launched whenever the chat is being ready
class ChatLoadingScreen extends ChatBlocState {}

// This state is launched whenever an error is detected in the chat process
class ChatErrorScreen extends ChatBlocState {
  final String errorMessage;

  ChatErrorScreen(this.errorMessage);
}
