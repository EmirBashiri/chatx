import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Entities/duplicate_entities.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/MessagesScreens/OtherMessagesScreen/bloc/other_messages_bloc.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class MessagesFunctions {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final StreamController fileStreamController = StreamController();
  Map<String, CancelToken> cancelTokens = {};

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
  String fechFileMessageTitle({required String messageUrl}) {
    // TODO change this with real logic on firebase storage
    final Uri uri = Uri.parse(messageUrl);
    return uri.pathSegments[1];
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
  CancelToken _buildCancelToken({required String messageUrl}) {
    final CancelToken cancelToken = CancelToken();
    cancelTokens.addAll({messageUrl: cancelToken});
    return cancelToken;
  }

  // Function to remove cancel token from cancel tokens map
  void _removeCancelToken({required String messageUrl}) {
    cancelTokens.remove(messageUrl);
  }

  // Funtion to downlodad file from storage server
  Future<void> downloadFile({
    required MessageEntity messageEntity,
    required OtherMessagesBloc otherMessagesBloc,
  }) async {
    final String filePath = await _fechMesssageFileCachePath(
      messageUrl: messageEntity.message,
    );
    final CancelToken cancelToken =
        _buildCancelToken(messageUrl: messageEntity.message);
    try {
      await Dio().download(
        messageEntity.message,
        filePath,
        cancelToken: cancelToken,
        onReceiveProgress: (count, total) {
          otherMessagesBloc.add(
            OtherMessagesDownloadStatus(
              messageEntity: messageEntity,
              downloadProgress:
                  DownloadProgress(downloaded: count, total: total),
            ),
          );
        },
      );
      _removeCancelToken(messageUrl: messageEntity.message);
      otherMessagesBloc.add(OtherMessagesFileCompleted(messageEntity));
    } catch (e) {
      otherMessagesBloc.add(OtherMessagesDownloadError(messageEntity));
    }
  }

  // Function to fech file dwonload progress
  double fechDownloadProgress(
      {required DownloadProgress downloadProgressStatus}) {
    return downloadProgressStatus.downloaded / downloadProgressStatus.total;
  }

  // Function to cancel all downloads
  void cancelAllDownloads() async {
    cancelTokens.forEach((key, value) {
      value.cancel();
    });
    cancelTokens.clear();
  }

  // Function to _cancel downloading
  void cancelDownload({required MessageEntity messageEntity}) {
    CancelToken? cancelToken = cancelTokens[messageEntity.message];
    cancelTokens.remove(messageEntity.message);
    cancelToken?.cancel();
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
      {required MessageEntity messageEntity, required OtherMessagesBloc otherMessagesBloc}) async {
    final File? file =
        await _getFileFromCache(messageUrl: messageEntity.message);
    if (file != null) {
      await _openFile(file: file);
    } else {
      otherMessagesBloc.add(OtherMessagesStart(messageEntity));
    }
  }
}
