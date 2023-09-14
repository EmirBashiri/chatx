import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/bloc/chat_bloc_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

import '../../../View/Widgets/widgets.dart';

// Server keys
const String messagesCollectionKey = "Messages";
const String messagesDocKey = "User Messages";

class ChatFunctions {
  // Instance of firestore to speak with DB
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Instance of message sender controller for use in whole class
  final MessageSenderController messageSenderController = Get.find();

  // Instance of firesore DB's stream
  StreamSubscription? chatStreamSubscription;

  // Map of cansel tokens for cansel downloads
  static Map<String, CancelToken> cancelTokens = {};

  // Map of upload tasks for cancel uploads
  static Map<String, UploadTask> uploadTasks = {};

  // Insrance of stop watch timer
  late StopWatchTimer stopWatchTimer;
  // Insrance of record for recording process
  final Record record = Record();

  // Function to build messages UUID
  String buildUUID() {
    const Uuid uuid = Uuid();
    return uuid.v1();
  }

  // Function to build messages UUID
  File fileRenamer({required File oldFile, required String fileId}) {
    final String parentPath = "${oldFile.path.split("cache").first}/cache";
    return oldFile.renameSync("$parentPath/$fileId");
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

  // Function to fech message file cached path
  Future<String> fechMesssageFileCachePath({required String messageId}) async {
    final Directory cacheDirectory = await getApplicationCacheDirectory();
    return "${cacheDirectory.path}/$messageId";
  }

  // Function to fech file name
  String fechFileName({required String filePath}) {
    return basename(filePath);
  }

  // Function to fech message that need upload
  MessageEntity _fechUploadNeededMessage(
      {required RoomIdRequirements roomIdRequirements,
      required MessageType messageType,
      required File oldFile,
      String? messageLabel}) {
    final String id = buildUUID();
    final File renamedFile = fileRenamer(oldFile: oldFile, fileId: id);
    return MessageEntity(
      id: id,
      senderUserId: roomIdRequirements.senderUserId,
      receiverUserId: roomIdRequirements.receiverUserId,
      messageContent: renamedFile.path,
      messageType: messageType,
      timestamp: Timestamp.now(),
      needUpload: true,
      messageLabel: messageLabel,
    );
  }

  // Function to send message to DB
  Future<void> _sendMessage({required MessageEntity messageEntity}) async {
    final RoomIdRequirements roomIdRequirements = RoomIdRequirements(
        senderUserId: messageEntity.senderUserId,
        receiverUserId: messageEntity.receiverUserId);

    await messagesCollection(roomIdRequirements: roomIdRequirements)
        .doc(messageEntity.id)
        .set(MessageEntity.toJson(messageEntity: messageEntity));
  }

  // Function to get messages docs from firebase firestroe DB
  Future<void> deleteMessageOnDB({required MessageEntity messageEntity}) async {
    final RoomIdRequirements roomIdRequirements = RoomIdRequirements(
        senderUserId: messageEntity.senderUserId,
        receiverUserId: messageEntity.receiverUserId);
    await messagesCollection(roomIdRequirements: roomIdRequirements)
        .doc(messageEntity.id)
        .delete();
  }

  // Function to show delete dialog
  Future<void> deleteChatMessageDialog(
      {required MessageEntity messageEntity}) async {
    // check if the message is uploading don't show the dialog until the upload is finished.
    if (!messageEntity.needUpload) {
      // calling this function to cancel possibe download process
      cancelDownload(messageEntity: messageEntity);
      showDialog(
        context: Get.context!,
        builder: (context) {
          return MessageDeleteDialog(
            chatFunctions: this,
            messageEntity: messageEntity,
          );
        },
      );
    }
  }

  // Function to delete chat message
  Future<void> deleteChatMessage({required MessageEntity messageEntity}) async {
    Get.back();
    await deleteMessageOnDB(messageEntity: messageEntity);
  }

  // Function to receive message from DB
  void getMessage(
      {required RoomIdRequirements roomIdRequirements,
      required ChatBloc chatBloc}) {
    final chatStream =
        messagesCollection(roomIdRequirements: roomIdRequirements)
            .orderBy(MessageEntity.timestampKey, descending: true)
            .snapshots();

    chatStreamSubscription = chatStream.listen((event) {
      final List<MessageEntity> messagesList = event.docs
          .map((jsonFromDB) => MessageEntity.fromJson(json: jsonFromDB.data()))
          .toList();
      chatBloc.add(ChatUpdate(messagesList));
    }, onError: (error) {
      chatBloc.add(ChatError(error));
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
  Future<void> closeChatScreen() async {
    await cancelAllUploads();
    await cancelAllDownloads();
    await chatStreamSubscription?.cancel();
    Get.back();
  }

  // Fuction to controll chat screen pop scope
  Future<bool> chatScreenPopScope() async {
    await cancelAllUploads();
    await cancelAllDownloads();
    await chatStreamSubscription?.cancel();
    return true;
  }

  // Function to _cancel downloading
  void cancelDownload({
    required MessageEntity messageEntity,
  }) {
    CancelToken? cancelToken = cancelTokens[messageEntity.id];
    cancelTokens.remove(messageEntity.id);
    cancelToken?.cancel();
  }

  // Function to cancel uploading
  Future<void> cancelUpload({required MessageEntity messageEntity}) async {
    final UploadTask? uploadTask = uploadTasks[messageEntity.id];
    uploadTasks.remove(messageEntity.id);
    await uploadTask?.cancel();
    await deleteMessageOnDB(messageEntity: messageEntity);
  }

  // Function to cancel all downloads
  Future<void> cancelAllDownloads() async {
    cancelTokens.forEach((key, value) {
      value.cancel();
    });
    cancelTokens.clear();
  }

  // Function to cancel all uploads
  Future<void> cancelAllUploads() async {
    uploadTasks.forEach((key, value) async {
      await value.cancel();
    });
    uploadTasks.clear();
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
      receiverUserId: roomIdRequirements.receiverUserId,
      messageContent: messageSenderController.senderTextController.text,
      messageType: MessageType.txt,
      timestamp: Timestamp.now(),
      needUpload: false,
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
      final MessageEntity messageEntity = _fechUploadNeededMessage(
        roomIdRequirements: roomIdRequirements,
        messageType: MessageType.other,
        oldFile: file,
        messageLabel: fechFileName(filePath: file.path),
      );
      await _sendMessage(messageEntity: messageEntity);
    }
  }

  // Function to compress image
  Future<File> _imageCompressor({required File imageFile}) async {
    File compressedImageFile;
    Future<File> compressImage({required int quality}) async {
      final String targetPath =
          "${imageFile.path}-compressed-${extension(imageFile.path)}";
      final XFile? compressor = await FlutterImageCompress.compressAndGetFile(
          imageFile.path, targetPath,
          quality: quality);
      imageFile.deleteSync(recursive: true);
      return File(compressor!.path);
    }

    // Convert bit to megabit
    final double imageSize = imageFile.lengthSync() / 1000000;
    if (imageSize < 1) {
      compressedImageFile = await compressImage(quality: 90);
      return compressedImageFile;
    } else if (imageSize < 3) {
      compressedImageFile = await compressImage(quality: 80);
      return compressedImageFile;
    } else if (imageSize < 6) {
      compressedImageFile = await compressImage(quality: 65);
      return compressedImageFile;
    } else {
      compressedImageFile = await compressImage(quality: 50);
      return compressedImageFile;
    }
  }

  // Fuction to pick file from user storage
  Future<File?> _pickImage() async {
    final XFile? xFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      final File file = File(xFile.path);
      return file;
    }
    return null;
  }

  // Fuction to start image sending operation
  Future<void> startImageSending(
      {required RoomIdRequirements roomIdRequirements}) async {
    Get.back();
    final File? imageFile = await _pickImage();
    if (imageFile != null) {
      // Compressing image for decrease image size and make it easy to render
      final File compressedImageFile =
          await _imageCompressor(imageFile: imageFile);
      final MessageEntity messageEntity = _fechUploadNeededMessage(
        roomIdRequirements: roomIdRequirements,
        messageType: MessageType.image,
        oldFile: compressedImageFile,
        messageLabel: fechFileName(filePath: imageFile.path),
      );
      await _sendMessage(messageEntity: messageEntity);
    }
  }

  // Fuction to start recording
  Future<void> startRecording({
    required RoomIdRequirements roomIdRequirements,
    required ColorScheme colorScheme,
  }) async {
    stopWatchTimer = StopWatchTimer();
    if (await record.hasPermission()) {
      await record.start();
      stopWatchTimer.onStartTimer();
      showModalBottomSheet(
        shape: const BeveledRectangleBorder(),
        context: Get.context!,
        backgroundColor: colorScheme.scrim,
        builder: (context) {
          return VoiceSenderSheet(
            stopWatchTimer: stopWatchTimer,
            chatFunctions: this,
            roomIdRequirements: roomIdRequirements,
          );
        },
      ).whenComplete(() async => await cancelRecording());
    }
  }

  // Fuction to send voice message
  Future<void> sendVoiceMessage(
      {required RoomIdRequirements roomIdRequirements}) async {
    Get.back();
    final String? audioFilePath = await _disposeRecordingTools();
    if (audioFilePath != null) {
      final MessageEntity messageEntity = _fechUploadNeededMessage(
          roomIdRequirements: roomIdRequirements,
          messageType: MessageType.other,
          oldFile: File(audioFilePath),
          messageLabel: fechFileName(filePath: audioFilePath));
      await _sendMessage(messageEntity: messageEntity);
    }
  }

  // Fuction to cancel recording
  Future<void> cancelRecording({bool? getBack}) async {
    await _disposeRecordingTools();
    if (getBack != null && getBack) {
      Get.back();
    }
  }

  // Fuction to dispose all recording tools
  Future<String?> _disposeRecordingTools() async {
    String? audioFilePath;
    if (stopWatchTimer.isRunning) {
      stopWatchTimer.onStopTimer();
      await stopWatchTimer.dispose();
    }
    audioFilePath = await record.stop();
    await record.dispose();
    return audioFilePath;
  }
}
