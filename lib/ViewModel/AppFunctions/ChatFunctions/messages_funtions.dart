import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Entities/duplicate_entities.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
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
    if (messageEntity.messageName != null) {
      return messageEntity.messageName!;
    } else {
      return fechFileName(filePath: messageEntity.message);
    }
  }

  // Function to fech message file cached path
  Future<String> _fechMesssageFileCachePath(
      {required String messageUrl}) async {
    final Directory cacheDirectory = await getApplicationCacheDirectory();
    return "${cacheDirectory.path}/$messageUrl";
  }

  // Function to check file availabelity
  Future<bool> isMessageFileDownloaded({required String messageUrl}) async {
    final filePath = await _fechMesssageFileCachePath(messageUrl: messageUrl);
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

  // Funtion to downlodad file from storage server
  Future<void> downloadFile({
    required MessageEntity messageEntity,
    required OtherMessagesBloc? otherMessagesBloc,
  }) async {
    final String filePath = await _fechMesssageFileCachePath(
      messageUrl: messageEntity.message,
    );
    final CancelToken cancelToken =
        _buildCancelToken(messageEntity: messageEntity);
    try {
      await Dio().download(
        messageEntity.message,
        filePath,
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
  Future<File?> _getFileFromCache({required String messageUrl}) async {
    final String filePath =
        await _fechMesssageFileCachePath(messageUrl: messageUrl);
    final File file = File(filePath);
    if (file.existsSync()) {
      return file;
    } else {
      return null;
    }
  }

  // Function to get image file from cache
  Future<File?> _getImageFromCache({required String imageUrl}) async {
    final File? file = await getCachedImageFile(imageUrl);
    if (file != null) {
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
    final File? file =
        await _getImageFromCache(imageUrl: messageEntity.message);
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
    final File? file =
        await _getFileFromCache(messageUrl: messageEntity.message);
    if (file != null) {
      await _openFile(file: file);
    } else {
      otherMessagesBloc.add(OtherMessagesStart(messageEntity));
    }
  }

  // Function to copy file to new file
  Future<void> _copyFile({
    required MessageEntity newMessageEntity,
    required File oldFile,
  }) async {
    final Directory directory = await getApplicationCacheDirectory();
    final File newFile = File("${directory.path}/${newMessageEntity.message}");
    if (!newFile.existsSync()) {
      newFile.createSync(recursive: true);
      oldFile.copy(newFile.path);
      oldFile.deleteSync(recursive: true);
    }
  }

  // Function to update message on DB
  Future<void> _updateMessageOnDB({
    required MessageEntity newMessageEntity,
    required MessageEntity oldMessageEntity,
  }) async {
    final RoomIdRequirements roomIdRequirements = RoomIdRequirements(
      senderUserId: oldMessageEntity.senderUserId,
      receiverUserId: oldMessageEntity.receiverUserID,
    );
    String docId = "";
    final List<QueryDocumentSnapshot<Object?>> docs =
        await _messagesDocs(messageEntity: oldMessageEntity);

    for (var doc in docs) {
      if (doc.get(MessageEntity.messageKey) == oldMessageEntity.message) {
        docId = doc.id;
      }
    }

    await messagesCollection(roomIdRequirements: roomIdRequirements)
        .doc(docId)
        .update(MessageEntity.toJson(messageEntity: newMessageEntity));
  }

  // Function to get messages docs from firebase firestroe DB
  Future<List<QueryDocumentSnapshot<Object?>>> _messagesDocs({
    required MessageEntity messageEntity,
  }) async {
    final RoomIdRequirements roomIdRequirements = RoomIdRequirements(
      senderUserId: messageEntity.senderUserId,
      receiverUserId: messageEntity.receiverUserID,
    );

    final QuerySnapshot querySnapshot =
        await messagesCollection(roomIdRequirements: roomIdRequirements).get();

    return querySnapshot.docs;
  }

  // Function to get messages docs from firebase firestroe DB
  Future<void> _deleteMessageOnDB({
    required MessageEntity messageEntity,
  }) async {
    final List<QueryDocumentSnapshot<Object?>> docs =
        await _messagesDocs(messageEntity: messageEntity);

    for (var doc in docs) {
      if (doc.get(MessageEntity.messageKey) == messageEntity.message) {
        await doc.reference.delete();
      }
    }
  }

  // Function to uplead file on server and send file message
  Future<void> uploadFileMessage({
    required OtherMessagesBloc otherMessagesBloc,
    required MessageEntity messageEntity,
  }) async {
    final String fileName = fechFileName(filePath: messageEntity.message);
    final File messageFile = File(messageEntity.message);
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
          receiverUserID: messageEntity.receiverUserID,
          message: downloadUrl,
          messageType: messageEntity.messageType,
          timestamp: messageEntity.timestamp,
          isUploading: false,
          messageName: messageEntity.messageName,
        );
        await _copyFile(
            newMessageEntity: newMessageEntity, oldFile: messageFile);
        await _updateMessageOnDB(
          newMessageEntity: newMessageEntity,
          oldMessageEntity: messageEntity,
        );
        otherMessagesBloc.add(OtherMessagesFileCompleted());
      } else if (snapshot.state == TaskState.error) {
        otherMessagesBloc.add(OtherMessagesUploadError());
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
