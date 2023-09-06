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

  // Function to fech messages collection from firebase firestore DB
  CollectionReference<Map<String, dynamic>> messagesCollection(
      {required RoomIdRequirements roomIdRequirements}) {
    return _firestore
        .collection(messagesCollectionKey)
        .doc(messagesDocKey)
        .collection(
          buildRoomId(roomIdRequirements: roomIdRequirements),
        );
  }

  // Function to fech file name
  String fechFileName({required String filePath}) {
    return basename(filePath);
  }

  // Function to send message to DB
  Future<void> _sendMessage({required MessageEntity messageEntity}) async {
    final RoomIdRequirements roomIdRequirements = RoomIdRequirements(
        senderUserId: messageEntity.senderUserId,
        receiverUserId: messageEntity.receiverUserID);

    await messagesCollection(roomIdRequirements: roomIdRequirements)
        .add(MessageEntity.toJson(messageEntity: messageEntity));
  }

  // Function to receive message from DB
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessage(
      {required RoomIdRequirements roomIdRequirements}) {
    return messagesCollection(roomIdRequirements: roomIdRequirements)
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
  Future<void> closeChatScreen() async {
    await cancelAllUploads();
    await cancelAllDownloads();
    Get.back();
  }

  // Fuction to controll chat screen pop scope
  Future<bool> chatScreenPopScope() async {
    await cancelAllUploads();
    await cancelAllDownloads();
    return true;
  }

  // Function to cancel all downloads
  Future<void> cancelAllDownloads() async {
    MessagesFunctions.cancelTokens.forEach((key, value) {
      value.cancel();
    });
    MessagesFunctions.cancelTokens.clear();
  }

  // Function to cancel all uploads
  Future<void> cancelAllUploads() async {
    MessagesFunctions.uploadTasks.forEach((key, value) async {
      await value.cancel();
    });
    MessagesFunctions.uploadTasks.clear();
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
  Future<void> startFileSending(
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
      await messagesCollection(roomIdRequirements: roomIdRequirements)
          .add(MessageEntity.toJson(messageEntity: messageEntity));
    }
  }
}
