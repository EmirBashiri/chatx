import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/ChatBloc/chat_bloc.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/MessagesScreens/ImageMessageScreen/image_message_screen.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/MessagesScreens/OtherMessagesScreen/othet_messages_screen.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/MessagesScreens/TextMessageScreen/text_message_screen.dart';
import 'package:flutter_chatx/View/Theme/icons.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/chat_function.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/messages_funtions.dart';
import 'package:get/get.dart';

// Application chat screen
class ChatScreen extends StatelessWidget {
  ChatScreen({super.key, required this.senderUser, required this.receiverUser});

  final AppUser senderUser;
  final AppUser receiverUser;

  final DependencyController dependencyController = Get.find();
  final MessageSenderController senderController = Get.find();
  late final ChatFunctions chatFunctions =
      dependencyController.appFunctions.chatFunctions;
  late final MessagesFunctions messagesFunctions =
      dependencyController.appFunctions.messagesFunctions;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async => await chatFunctions.closeChatScreen(
            messagesFunctions: messagesFunctions,
          ),
          icon: Icon(backIcon, color: colorScheme.primary),
        ),
        forceMaterialTransparency: true,
        centerTitle: true,
        title: Text(
          chatFunctions.fechChatScreenTitle(
            senderUser: senderUser,
            receiverUser: receiverUser,
          ),
          style: textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: BlocProvider(
        create: (context) {
          final blox = ChatBloc();
          blox.add(
            ChatStart(
              RoomIdRequirements(
                senderUserId: senderUser.userUID,
                receiverUserId: receiverUser.userUID,
              ),
            ),
          );
          return blox;
        },
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoadingScreen) {
              return const CustomLoadingScreen();
            } else if (state is ChatMainScreen) {
              return _ChatMainWidget(
                messagesList: state.messagesList,
                messagesFunctions: messagesFunctions,
                chatFunctions: chatFunctions,
                senderController: senderController,
                roomIdRequirements: RoomIdRequirements(
                  senderUserId: senderUser.userUID,
                  receiverUserId: receiverUser.userUID,
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

// Chat screen main widget
class _ChatMainWidget extends StatelessWidget {
  const _ChatMainWidget({
    required this.messagesList,
    required this.messagesFunctions,
    required this.senderController,
    required this.chatFunctions,
    required this.roomIdRequirements,
  });

  final List<MessageEntity> messagesList;
  final MessagesFunctions messagesFunctions;
  final MessageSenderController senderController;
  final ChatFunctions chatFunctions;
  final RoomIdRequirements roomIdRequirements;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Chat messages part
          _MainPart(
            messagesList: messagesList,
            messagesFunctions: messagesFunctions,
          ),
          // Chat message sender part
          _BottomPart(
            senderController: senderController,
            roomIdRequirements: roomIdRequirements,
            chatFunctions: chatFunctions,
          )
        ],
      ),
    );
  }
}

// Chat screen main part
class _MainPart extends StatelessWidget {
  const _MainPart({
    required this.messagesList,
    required this.messagesFunctions,
  });

  final List<MessageEntity> messagesList;
  final MessagesFunctions messagesFunctions;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        reverse: true,
        itemCount: messagesList.length,
        itemBuilder: (context, index) {
          final MessageEntity messageEntity = messagesList[index];
          switch (messageEntity.messageType) {
            case MessageType.txt:
              return TexetMessageScreen(
                messageEntity: messageEntity,
                messagesFunctions: messagesFunctions,
              );
            case MessageType.image:
              return ImageMessageScreen(
                  messageEntity: messageEntity,
                  messagesFunctions: messagesFunctions);
            case MessageType.other:
              return OthetMessagesScreen(
                messageEntity: messageEntity,
              );
          }
        },
      ),
    );
  }
}

// Chat screen bottom part (Message sender part)
class _BottomPart extends StatelessWidget {
  const _BottomPart({
    required this.senderController,
    required this.chatFunctions,
    required this.roomIdRequirements,
  });
  final MessageSenderController senderController;
  final ChatFunctions chatFunctions;
  final RoomIdRequirements roomIdRequirements;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          _SenderTextField(),
          _SenderRightAction(
            senderController: senderController,
            chatFunctions: chatFunctions,
            roomIdRequirements: roomIdRequirements,
          ),
        ],
      ),
    );
  }
}

// Chat message sender text field
class _SenderTextField extends StatelessWidget {
  _SenderTextField();

  final DependencyController dependencyController = Get.find();
  final MessageSenderController senderController = Get.find();
  late final ChatFunctions chatFunctions =
      dependencyController.appFunctions.chatFunctions;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Flexible(
      child: Container(
        height: Get.height * 0.075,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(24)),
        width: Get.width,
        child: TextField(
          keyboardType: TextInputType.multiline,
          controller: senderController.senderTextController,
          style: textTheme.bodyMedium,
          onChanged: chatFunctions.fechCanSendMessage,
          expands: true,
          minLines: null,
          maxLines: null,
          decoration: InputDecoration(
              hintText: typeMessage,
              hintStyle: textTheme.bodySmall,
              prefixIcon: CupertinoButton(
                onPressed: () {
                  // TODO implement file and image sender feature here
                },
                child: Icon(
                  paperClipIcon,
                  color: colorScheme.primary,
                ),
              ),
              border: InputBorder.none),
        ),
      ),
    );
  }
}

// Chat bottom sender part right part
class _SenderRightAction extends StatelessWidget {
  const _SenderRightAction({
    required this.senderController,
    required this.chatFunctions,
    required this.roomIdRequirements,
  });

  final MessageSenderController senderController;
  final ChatFunctions chatFunctions;
  final RoomIdRequirements roomIdRequirements;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Obx(
      () {
        return senderController.canSendText.value
            // Text message sender button
            ? IconButton.filled(
                onPressed: () async => await chatFunctions.sendTextMessage(
                  roomIdRequirements: roomIdRequirements,
                ),
                icon: Icon(paperPlaneIcon, color: colorScheme.background),
              )
            // Voice message sender button
            : IconButton.filled(
                onPressed: () {
                  //TODO Implement voice sending feature here
                },
                icon: Icon(microphoneIcon, color: colorScheme.background),
              );
      },
    );
  }
}
