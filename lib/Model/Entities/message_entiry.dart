// Server keys

const String _senderUserKey = "Sender User";
const String _receiverUserKey = "Receiver User Id";
const String _messageKey = "Message";
const String _messageTypeKey = "Message Type";

class MessageEntity {
  final String senderUserId;
  final String receiverUserID;
  final dynamic message;
  final MessageType messageType;

  MessageEntity({
    required this.senderUserId,
    required this.receiverUserID,
    required this.message,
    required this.messageType,
  });

  // Function to send message map to DB
  static Map<String, dynamic> toJson({required MessageEntity messageEntity}) {
    return {
      _senderUserKey: messageEntity.senderUserId,
      _receiverUserKey: messageEntity.receiverUserID,
      _messageKey: messageEntity.message,
      _messageTypeKey: messageEntity.messageType.name
    };
  }

  // Function to parse message entity from DB
  factory MessageEntity.fromJson({required Map<String, dynamic> json}) {
    return MessageEntity(
      senderUserId: json[_senderUserKey],
      receiverUserID: json[_receiverUserKey],
      message: json[_messageKey],
      messageType: MessageType.values
          .firstWhere((type) => type.name == json[_messageTypeKey]),
    );
  }
}

class RoomIdRequirements {
  final String senderUserId;
  final String receiverUserId;

  RoomIdRequirements(
      {required this.senderUserId, required this.receiverUserId});
}

enum MessageType { txt, image, other }
