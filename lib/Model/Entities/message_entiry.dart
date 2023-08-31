import 'package:cloud_firestore/cloud_firestore.dart';

class MessageEntity {
  final String senderUserId;
  final String receiverUserID;
  final dynamic message;
  final MessageType messageType;
  final Timestamp timestamp;
  final bool isUploading;

// Server keys
  static const String senderUserKey = "Sender User Id";
  static const String receiverUserKey = "Receiver User Id";
  static const String messageKey = "Message";
  static const String messageTypeKey = "Message Type";
  static const String timestampKey = "Time Stamp";
  static const String isUploadingKey = "Is Uploading";

  MessageEntity({
    required this.senderUserId,
    required this.receiverUserID,
    required this.message,
    required this.messageType,
    required this.timestamp,
    required this.isUploading,
  });

  // Function to send message map to DB
  static Map<String, dynamic> toJson({required MessageEntity messageEntity}) {
    return {
      senderUserKey: messageEntity.senderUserId,
      receiverUserKey: messageEntity.receiverUserID,
      messageKey: messageEntity.message,
      messageTypeKey: messageEntity.messageType.name,
      timestampKey: messageEntity.timestamp,
      isUploadingKey: messageEntity.isUploading,
    };
  }

  // Function to parse message entity from DB
  factory MessageEntity.fromJson({required Map<String, dynamic> json}) {
    return MessageEntity(
      senderUserId: json[senderUserKey],
      receiverUserID: json[receiverUserKey],
      message: json[messageKey],
      messageType: MessageType.values
          .firstWhere((type) => type.name == json[messageTypeKey]),
      timestamp: json[timestampKey],
      isUploading: json[isUploadingKey],
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
