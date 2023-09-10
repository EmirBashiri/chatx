import 'package:cloud_firestore/cloud_firestore.dart';

class MessageEntity {
  final String id;
  final String senderUserId;
  final String receiverUserId;
  final String messageContent;
  final MessageType messageType;
  final Timestamp timestamp;
  final bool needUpload;
  final String? messageLabel;

// Server keys
  static const String idKey = "Id";
  static const String senderUserKey = "Sender User Id";
  static const String receiverUserKey = "Receiver User Id";
  static const String messageKey = "Message Content";
  static const String messageTypeKey = "Message Type";
  static const String timestampKey = "Time Stamp";
  static const String isUploadingKey = "Need Upload";
  static const String messageNameKey = "Message Label";

  MessageEntity({
    required this.id,
    required this.senderUserId,
    required this.receiverUserId,
    required this.messageContent,
    required this.messageType,
    required this.timestamp,
    required this.needUpload,
    this.messageLabel,
  });

  // Function to send message map to DB
  static Map<String, dynamic> toJson({required MessageEntity messageEntity}) {
    return {
      idKey: messageEntity.id,
      senderUserKey: messageEntity.senderUserId,
      receiverUserKey: messageEntity.receiverUserId,
      messageKey: messageEntity.messageContent,
      messageTypeKey: messageEntity.messageType.name,
      timestampKey: messageEntity.timestamp,
      isUploadingKey: messageEntity.needUpload,
      messageNameKey: messageEntity.messageLabel
    };
  }

  // Function to parse message entity from DB
  factory MessageEntity.fromJson({required Map<String, dynamic> json}) {
    return MessageEntity(
      id: json[idKey],
      senderUserId: json[senderUserKey],
      receiverUserId: json[receiverUserKey],
      messageContent: json[messageKey],
      messageType: MessageType.values
          .firstWhere((type) => type.name == json[messageTypeKey]),
      timestamp: json[timestampKey],
      needUpload: json[isUploadingKey],
      messageLabel: json[messageNameKey],
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
