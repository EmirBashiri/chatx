import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/MessageBox/bloc/message_box_bloc.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/bloc/chat_bloc.dart';

// Server keys
const String messagesCollectionKey = "Messages";
const String messagesDocKey = "User Messages";

class ChatFunctions {
  // Instance of firestore to speak with DB
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
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

  // Funtion to downlodad file from storage server

  Stream<FileResponse> downloadFile(
      {required String fileUrl, required MessageBoxBloc messageBoxBloc}) {
    final Stream<FileResponse> stream =
        DefaultCacheManager().getFileStream(fileUrl, withProgress: true);
    // stream.listen(
    //   (event) {
    //     if (event is FileInfo) {
    //       // TODO implement add download completed event
    //       print(event);
    //     }
    //   },
    // );
    return stream;
  }

  // Function to fech message align
  Alignment fechMessageAlign({required String senderUserId}) {
    if (senderUserId == _firebaseAuth.currentUser!.uid) {
      return Alignment.bottomRight;
    } else {
      return Alignment.bottomLeft;
    }
  }

  // Function to fech  message box border
  BorderRadiusGeometry fechMessageBorder({required String senderUserId}) {
    const Radius duplicateRadius = Radius.circular(12);

    if (senderUserId == _firebaseAuth.currentUser!.uid) {
      return const BorderRadiusDirectional.only(
        topStart: duplicateRadius,
        topEnd: duplicateRadius,
        bottomStart: duplicateRadius,
      );
    } else {
      return const BorderRadiusDirectional.only(
        topStart: duplicateRadius,
        topEnd: duplicateRadius,
        bottomEnd: duplicateRadius,
      );
    }
  }

  // Function to fech message box color
  Color fechMessageBoxColor(
      {required String senderUserId, required ColorScheme colorScheme}) {
    if (senderUserId == _firebaseAuth.currentUser!.uid) {
      return colorScheme.primaryContainer;
    } else {
      return colorScheme.primary;
    }
  }

  // Function to fech message box color
  Color _fechMessageOnBoxColor(
      {required String senderUserId, required ColorScheme colorScheme}) {
    if (senderUserId == _firebaseAuth.currentUser!.uid) {
      return colorScheme.secondary;
    } else {
      return colorScheme.background;
    }
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

  Text buildCustomTextWidget(
      {required TextTheme textTheme,
      required MessageEntity messageEntity,
      required String text,
      required ColorScheme colorScheme}) {
    return Text(
      text,
      style: textTheme.bodyMedium!.copyWith(
        fontWeight: FontWeight.w600,
        color: _fechMessageOnBoxColor(
            senderUserId: messageEntity.senderUserId, colorScheme: colorScheme),
      ),
      overflow: TextOverflow.clip,
    );
  }
}
