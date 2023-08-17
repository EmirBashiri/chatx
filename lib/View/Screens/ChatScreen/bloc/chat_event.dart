part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

// Event called whenever chat screen starting up
class ChatStart extends ChatEvent {
  final RoomIdRequirements roomIdRequirements;

  ChatStart(this.roomIdRequirements);
}

// Event called whenever state should update
class ChatUpdate extends ChatEvent {
  final List<MessageEntity> messagesList;

  ChatUpdate(this.messagesList);
}
