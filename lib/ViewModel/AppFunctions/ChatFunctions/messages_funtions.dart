import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/MessagesScreens/OtherMessagesScreen/bloc/other_messages_bloc.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:open_file/open_file.dart';

class MessagesFunctions {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final StreamController fileStreamController = StreamController();
  static Map<String, StreamSubscription?> subscriptionList = {};

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

  // Function to check file availabelity
  Future<bool> isMessageFileDownloaded({required messageUrl}) async {
    final DefaultCacheManager cacheManager = DefaultCacheManager();
    final FileInfo? fileInfo = await cacheManager.store.getFile(messageUrl);
    if (fileInfo != null && fileInfo.file.existsSync()) {
      return true;
    }
    return false;
  }

  // Function to listen download stream
  void _listenToDownloadStream(
      {required Stream stream,
      required MessageEntity messageEntity,
      required OtherMessagesBloc messagesBloc}) {
    final StreamSubscription subscription = stream.listen(
      (event) {
        if (event is FileInfo) {
          messagesBloc.add(OtherMessagesFileCompleted(messageEntity));
        }
      },
    );
    final Map<String, StreamSubscription?> subscriptionEntity = {
      messageEntity.message: subscription
    };
    subscriptionList.addEntries(subscriptionEntity.entries);
  }

  // Funtion to downlodad file from storage server
  Stream<FileResponse> downloadFile({
    required MessageEntity messageEntity,
    required OtherMessagesBloc otherMessagesBloc,
  }) {
    final Stream<FileResponse> stream = DefaultCacheManager()
        .getFileStream(messageEntity.message, withProgress: true)
        .asBroadcastStream();

    _listenToDownloadStream(
      stream: stream,
      messageEntity: messageEntity,
      messagesBloc: otherMessagesBloc,
    );

    return stream;
  }

  // Function to cancel all download streams
  Future<void> cancelDownloadStreams() async {
    subscriptionList.forEach((key, value) async {
      await value?.cancel();
    });
    subscriptionList.clear();
  }

  // Function to get message file from cache
  Future<File?> _getFileFromCache({required String messageUrl}) async {
    final DefaultCacheManager cacheManager = DefaultCacheManager();
    final FileInfo? fileInfo = await cacheManager.getFileFromCache(messageUrl);
    if (fileInfo != null) {
      return fileInfo.file;
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

  // Function to open file
  Future<void> openFile(
      {required MessageEntity messageEntity, required Emitter emitter}) async {
    final File? file =
        await _getFileFromCache(messageUrl: messageEntity.message);
    if (file != null) {
      await _openFile(file: file);
    } else {
      emitter.call(MessageFileDownloadingScreen(
          messageEntity: messageEntity, messagesFunctions: this));
    }
  }
}
