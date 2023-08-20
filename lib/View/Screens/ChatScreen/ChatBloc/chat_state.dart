part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

class ChatLoadingScreen extends ChatState {}

class ChatMainScreen extends ChatState {
  final List<MessageEntity> messagesList;

  ChatMainScreen(this.messagesList);
}

class ChatEmptyScreen extends ChatState {}

class ChatErrorScreen extends ChatState {
  final String errorMessage;

  ChatErrorScreen(this.errorMessage);
}
