import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/messages_funtions.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

// Server keys
const String messagesCollectionKey = "Messages";
const String messagesDocKey = "User Messages";

class ChatFunctions {
  // Instance of firestore to speak with DB
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Instance of message sender controller for use in whole class
  final MessageSenderController messageSenderController = Get.find();

  // Function to build messages UUID
  String buildUUID() {
    const Uuid uuid = Uuid();
    return uuid.v1();
  }

  // Function to build room id
  String buildRoomId({required RoomIdRequirements roomIdRequirements}) {
    final List<String> userIdList = [
      roomIdRequirements.senderUserId,
      roomIdRequirements.receiverUserId,
    ];
    userIdList.sort();
    return userIdList.join("_");
  }

  // Function to fech file name
  String fechFileName({required String filePath}) {
    return basename(filePath);
  }

  // Function to send message to DB
  Future<void> _sendMessage({required MessageEntity messageEntity}) async {
    final String roomId = buildRoomId(
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
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessage(
      {required RoomIdRequirements roomIdRequirements}) {
    final String roomId = buildRoomId(roomIdRequirements: roomIdRequirements);
    return _firestore
        .collection(messagesCollectionKey)
        .doc(messagesDocKey)
        .collection(roomId)
        .orderBy(MessageEntity.timestampKey, descending: true)
        .snapshots();
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
    messagesFunctions.cancelAllDownloads();
    Get.back();
  }

  // Fuction to fech can send message status
  void fechCanSendMessage(String textFieldValue) {
    if (textFieldValue.isNotEmpty) {
      messageSenderController.canSendText.value = true;
    } else {
      messageSenderController.canSendText.value = false;
    }
  }

  // Fuction to send text message
  Future<void> sendTextMessage(
      {required RoomIdRequirements roomIdRequirements}) async {
    final MessageEntity messageEntity = MessageEntity(
      id: buildUUID(),
      senderUserId: roomIdRequirements.senderUserId,
      receiverUserID: roomIdRequirements.receiverUserId,
      message: messageSenderController.senderTextController.text,
      messageType: MessageType.txt,
      timestamp: Timestamp.now(),
      isUploading: false,
    );
    messageSenderController.senderTextController.clear();
    messageSenderController.canSendText.value = false;
    await _sendMessage(messageEntity: messageEntity);
  }

  // Fuction to pick file from user storage
  Future<File?> _pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final File file = File(result.files.single.path!);
      return file;
    }
    return null;
  }

  // Fuction to start file sending operation
  Future<void> startFileUploading(
      {required RoomIdRequirements roomIdRequirements}) async {
    Get.back();
    final File? file = await _pickFile();
    if (file != null) {
      final MessageEntity messageEntity = MessageEntity(
        id: buildUUID(),
        senderUserId: roomIdRequirements.senderUserId,
        receiverUserID: roomIdRequirements.receiverUserId,
        message: file.path,
        messageType: MessageType.other,
        timestamp: Timestamp.now(),
        isUploading: true,
        messageName: fechFileName(filePath: file.path),
      );
      await _firestore
          .collection(messagesCollectionKey)
          .doc(messagesDocKey)
          .collection(buildRoomId(roomIdRequirements: roomIdRequirements))
          .add(MessageEntity.toJson(messageEntity: messageEntity));
    }
  }
}
