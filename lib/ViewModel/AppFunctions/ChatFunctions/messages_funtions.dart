import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Entities/duplicate_entities.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/MessagesScreens/ImageMessageScreen/bloc/image_message_bloc.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/MessagesScreens/OtherMessagesScreen/bloc/other_messages_bloc.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/chat_function.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class MessagesFunctions extends ChatFunctions {
  // Insrance of firebase auth for use in whole file
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Insrance of firebase storage for use in whole file
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // Map of cansel tokens for cansel downloads
  static Map<String, CancelToken> cancelTokens = {};

  // Map of upload tasks for cancel uploads
  static Map<String, UploadTask> uploadTasks = {};

  // Function to check message sender is applications current user or not
  bool senderIsCurrentUser({required MessageEntity messageEntity}) {
    if (messageEntity.senderUserId == _firebaseAuth.currentUser!.uid) {
      return true;
    } else {
      return false;
    }
  }

  // Function to buid time stamp widget
  String messageTimeStamp({required Timestamp timestamp}) {
    final DateTime dateTime = timestamp.toDate();
    return "${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}";
  }

  // Function to buid message title
  String fechFileMessageTitle({required MessageEntity messageEntity}) {
    if (messageEntity.messageLabel != null) {
      return messageEntity.messageLabel!;
    } else {
      return fechFileName(filePath: messageEntity.messageContent);
    }
  }

  // Function to fech message file cached path
  Future<String> _fechMesssageFileCachePath({required String messageId}) async {
    final Directory cacheDirectory = await getApplicationCacheDirectory();
    return "${cacheDirectory.path}/$messageId";
  }

  // Function to download file from internet
  Future<void> _customDownloader(
      {required MessageEntity messageEntity,
      required CancelToken cancelToken,
      required void Function(int, int)? onReceiveProgress}) async {
    final String filePath = await _fechMesssageFileCachePath(
      messageId: messageEntity.id,
    );

    await Dio().download(
      messageEntity.messageContent,
      filePath,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  // Function to check file availabelity
  Future<bool> isFileDownloaded({required String messageId}) async {
    final filePath = await _fechMesssageFileCachePath(messageId: messageId);
    final File file = File(filePath);
    if (file.existsSync()) {
      return true;
    }
    return false;
  }

  // Function to build cansel token and add to tokens maps
  CancelToken _buildCancelToken({required MessageEntity messageEntity}) {
    final CancelToken cancelToken = CancelToken();
    cancelTokens.addAll({messageEntity.id: cancelToken});
    return cancelToken;
  }

  // Function to remove cancel token from cancel tokens map
  void _removeCancelToken({required MessageEntity messageEntity}) {
    cancelTokens.remove(messageEntity.id);
  }

  // Funtion to download file from storage server
  Future<void> downloadFile({
    required MessageEntity messageEntity,
    required OtherMessagesBloc? otherMessagesBloc,
  }) async {
    final CancelToken cancelToken =
        _buildCancelToken(messageEntity: messageEntity);
    try {
      await _customDownloader(
        messageEntity: messageEntity,
        cancelToken: cancelToken,
        onReceiveProgress: (count, total) {
          otherMessagesBloc?.add(
            OtherMessagesDownloadingStatus(
              OperationProgress(transferred: count, total: total),
            ),
          );
        },
      );
      _removeCancelToken(messageEntity: messageEntity);
      otherMessagesBloc!.add(OtherMessagesFileCompleted());
    } catch (e) {
      otherMessagesBloc!.add(OtherMessagesDownloadError());
      otherMessagesBloc = null;
    }
  }

  // Funtion to download image from storage server
  Future<void> downloadImageFile({
    required MessageEntity messageEntity,
    required ImageMessageBloc? imageMessageBloc,
  }) async {
    final CancelToken cancelToken =
        _buildCancelToken(messageEntity: messageEntity);
    try {
      await _customDownloader(
        messageEntity: messageEntity,
        cancelToken: cancelToken,
        onReceiveProgress: (count, total) {
          imageMessageBloc?.add(
            ImageMessageDownloadProgress(
                OperationProgress(transferred: count, total: total)),
          );
        },
      );
      _removeCancelToken(messageEntity: messageEntity);
      final File? imageFile =
          await getFileFromCache(messageId: messageEntity.id);
      imageMessageBloc!.add(ImageMessageOperationComplete(imageFile!));
    } catch (e) {
      imageMessageBloc!.add(ImageMessageDownloadError());
      imageMessageBloc = null;
    }
  }

  // Function to _cancel downloading
  void cancelDownload({
    required MessageEntity messageEntity,
  }) {
    CancelToken? cancelToken = cancelTokens[messageEntity.id];
    cancelTokens.remove(messageEntity.id);
    cancelToken?.cancel();
  }

  // Function to fech file dwonload progress
  double fechOperationProgress({required OperationProgress operationProgress}) {
    return operationProgress.transferred / operationProgress.total;
  }

  // Function to get message file from cache
  Future<File?> getFileFromCache({required String messageId}) async {
    final String filePath =
        await _fechMesssageFileCachePath(messageId: messageId);
    final File file = File(filePath);
    if (file.existsSync()) {
      return file;
    } else {
      return null;
    }
  }

  // Function to open files
  Future<OpenResult> _openFile({required File file}) async {
    final OpenResult openResult = await OpenFile.open(file.path);
    if (openResult.type == ResultType.error ||
        openResult.type == ResultType.fileNotFound ||
        openResult.type == ResultType.noAppToOpen) {
      showSnakeBar(title: appName, message: openResult.message);
    }
    return openResult;
  }

  // Function to open image
  Future<void> openImage({required MessageEntity messageEntity}) async {
    final File? file = await getFileFromCache(messageId: messageEntity.id);
    if (file != null) {
      await _openFile(file: file);
    } else {
      showSnakeBar(title: appName, message: defaultErrorMessage);
    }
  }

  // Function to open message file
  Future<void> openFileMessage(
      {required MessageEntity messageEntity,
      required OtherMessagesBloc otherMessagesBloc}) async {
    final File? file = await getFileFromCache(messageId: messageEntity.id);
    if (file != null) {
      await _openFile(file: file);
    } else {
      otherMessagesBloc.add(OtherMessagesStart(messageEntity));
    }
  }

  // Function to update message on DB
  Future<void> _updateMessageOnDB(
      {required MessageEntity newMessageEntity}) async {
    final RoomIdRequirements roomIdRequirements = RoomIdRequirements(
      senderUserId: newMessageEntity.senderUserId,
      receiverUserId: newMessageEntity.receiverUserId,
    );
    await messagesCollection(roomIdRequirements: roomIdRequirements)
        .doc(newMessageEntity.id)
        .update(MessageEntity.toJson(messageEntity: newMessageEntity));
  }

  // Function to get messages docs from firebase firestroe DB
  Future<void> _deleteMessageOnDB(
      {required MessageEntity messageEntity}) async {
    final RoomIdRequirements roomIdRequirements = RoomIdRequirements(
        senderUserId: messageEntity.senderUserId,
        receiverUserId: messageEntity.receiverUserId);
    await messagesCollection(roomIdRequirements: roomIdRequirements)
        .doc(messageEntity.id)
        .delete();
  }

  // Function to uplead file on server and send file message
  Future<void> uploadFileMessage({
    required OtherMessagesBloc otherMessagesBloc,
    required MessageEntity messageEntity,
  }) async {
    final String fileName =
        fechFileName(filePath: messageEntity.messageContent);
    final File messageFile = File(messageEntity.messageContent);
    final Reference reference =
        _firebaseStorage.ref("$fileMessagesBucket$fileName");
    final UploadTask uploadTask = reference.putFile(messageFile);
    uploadTasks.addAll({messageEntity.id: uploadTask});
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) async {
      if (snapshot.state == TaskState.running) {
        otherMessagesBloc.add(
          OtherMessagesUploadingStatus(
            OperationProgress(
              transferred: snapshot.bytesTransferred,
              total: snapshot.totalBytes,
            ),
          ),
        );
      } else if (snapshot.state == TaskState.success) {
        uploadTasks.remove(messageEntity.id);
        otherMessagesBloc.add(OtherMessagesLoading());
        final String downloadUrl = await reference.getDownloadURL();
        final MessageEntity newMessageEntity = MessageEntity(
          id: messageEntity.id,
          senderUserId: messageEntity.senderUserId,
          receiverUserId: messageEntity.receiverUserId,
          messageContent: downloadUrl,
          messageType: messageEntity.messageType,
          timestamp: messageEntity.timestamp,
          needUpload: false,
          messageLabel: messageEntity.messageLabel,
        );
        await _updateMessageOnDB(newMessageEntity: newMessageEntity);
        otherMessagesBloc.add(OtherMessagesFileCompleted());
      } else if (snapshot.state == TaskState.error) {
        otherMessagesBloc.add(OtherMessagesUploadError());
      }
    });
  }

  // Function to uplead image on server and send file message
  Future<void> uploadImageMessage({
    required ImageMessageBloc imageMessageBloc,
    required MessageEntity messageEntity,
  }) async {
    final String fileName =
        fechFileName(filePath: messageEntity.messageContent);
    final File imageFile = File(messageEntity.messageContent);
    final Reference reference =
        _firebaseStorage.ref("$imageMessagesBucket$fileName");
    final UploadTask uploadTask = reference.putFile(imageFile);
    uploadTasks.addAll({messageEntity.id: uploadTask});
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) async {
      if (snapshot.state == TaskState.running) {
        imageMessageBloc.add(
          ImageMessageUploadProgress(
            operationProgress: OperationProgress(
              transferred: snapshot.bytesTransferred,
              total: snapshot.totalBytes,
            ),
            imageFile: imageFile,
          ),
        );
      } else if (snapshot.state == TaskState.success) {
        uploadTasks.remove(messageEntity.id);
        imageMessageBloc.add(ImageMessageLoading());
        final String downloadUrl = await reference.getDownloadURL();
        final MessageEntity newMessageEntity = MessageEntity(
          id: messageEntity.id,
          senderUserId: messageEntity.senderUserId,
          receiverUserId: messageEntity.receiverUserId,
          messageContent: downloadUrl,
          messageType: messageEntity.messageType,
          timestamp: messageEntity.timestamp,
          needUpload: false,
          messageLabel: messageEntity.messageLabel,
        );
        await _updateMessageOnDB(newMessageEntity: newMessageEntity);
        final File? imageFile =
            await getFileFromCache(messageId: newMessageEntity.id);
        imageMessageBloc.add(ImageMessageOperationComplete(imageFile!));
      } else if (snapshot.state == TaskState.error) {
        final File? imageFile =
            await getFileFromCache(messageId: messageEntity.id);
        imageMessageBloc.add(ImageMessageUploadError(imageFile: imageFile));
      }
    });
  }

  // Function to cancel uploading
  Future<void> cancelUpload({required MessageEntity messageEntity}) async {
    final UploadTask? uploadTask = uploadTasks[messageEntity.id];
    uploadTasks.remove(messageEntity.id);
    await uploadTask!.cancel();
    await _deleteMessageOnDB(messageEntity: messageEntity);
  }

  // Function to delete message that gave an error
  Future<void> deleteErroredMessage(
      {required MessageEntity messageEntity}) async {
    await _deleteMessageOnDB(messageEntity: messageEntity);
  }
}
