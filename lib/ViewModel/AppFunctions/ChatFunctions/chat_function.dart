import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/ChatBloc/chat_bloc.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/messages_funtions.dart';
import 'package:get/get.dart';

// Server keys
const String messagesCollectionKey = "Messages";
const String messagesDocKey = "User Messages";

class ChatFunctions {
  // Instance of firestore to speak with DB
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to build room id
  String _buildRoomId({required RoomIdRequirements roomIdRequirements}) {
    final List<String> userIdList = [
      roomIdRequirements.senderUserId,
      roomIdRequirements.receiverUserId,
    ];
    userIdList.sort();
    return userIdList.join("_");
  }

  // Function to  send message to DB
  Future<void> sendMessage({required MessageEntity messageEntity}) async {
    final String roomId = _buildRoomId(
      roomIdRequirements: RoomIdRequirements(
          senderUserId: messageEntity.senderUserId,
          receiverUserId: messageEntity.receiverUserID),
    );
    await _firestore
        .collection(messagesCollectionKey)
        .doc(messagesDocKey)
        .collection(roomId)
        .add(MessageEntity.toJson(messageEntity: messageEntity));
  }

  // Function to receive message from DB
  void getMessage(
      {required RoomIdRequirements roomIdRequirements,
      required ChatBloc chatBloc}) {
    final String roomId = _buildRoomId(roomIdRequirements: roomIdRequirements);
    final streamToDB = _firestore
        .collection(messagesCollectionKey)
        .doc(messagesDocKey)
        .collection(roomId)
        .orderBy(MessageEntity.timestampKey, descending: true)
        .snapshots();
    List<MessageEntity> messagesList = [];
    streamToDB.listen((event) {
      messagesList = event.docs
          .map((jsonFromDB) => MessageEntity.fromJson(json: jsonFromDB.data()))
          .toList();
      chatBloc.add(ChatUpdate(messagesList));
    });
  }

  // Fuction to fech chat screen title
  String fechChatScreenTitle(
      {required AppUser senderUser, required AppUser receiverUser}) {
    if (senderUser.userUID != receiverUser.userUID) {
      return receiverUser.fullName ?? receiverUser.email;
    } else {
      return savedMessages;
    }
  }

  // Fuction to close chat screen
  Future<void> closeChatScreen(
      {required MessagesFunctions messagesFunctions}) async {
    await messagesFunctions.cancelDownloadStreams();
    Get.back();
  }
}
