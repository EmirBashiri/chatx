import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/MessagesScreens/ImageMessageScreen/image_message_screen.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/MessagesScreens/OtherMessagesScreen/othet_messages_screen.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/MessagesScreens/TextMessageScreen/text_message_screen.dart';
import 'package:flutter_chatx/View/Theme/icons.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/chat_function.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/messages_funtions.dart';
import 'package:get/get.dart';

import 'bloc/chat_bloc_bloc.dart';

// Application's chat screen
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
  late final RoomIdRequirements roomIdRequirements = RoomIdRequirements(
      senderUserId: senderUser.userUID, receiverUserId: receiverUser.userUID);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return WillPopScope(
      onWillPop: () async => await chatFunctions.chatScreenPopScope(),
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () async => await chatFunctions.closeChatScreen(),
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
              final bloc = ChatBloc(roomIdRequirements);
              bloc.add(ChatStart());
              return bloc;
            },
            child: BlocBuilder<ChatBloc, ChatBlocState>(
              builder: (context, state) {
                if (state is ChatLoadingScreen) {
                  return const CustomLoadingScreen();
                } else if (state is ChatMainScreen) {
                  return _ChatMainWidget(
                    messagesList: state.messagesList,
                    messagesFunctions: messagesFunctions,
                    senderController: senderController,
                    chatFunctions: chatFunctions,
                    roomIdRequirements: roomIdRequirements,
                  );
                } else if (state is EmptyChatScreen) {
                  return _EmptyChatWidget(
                    senderController: senderController,
                    roomIdRequirements: roomIdRequirements,
                    chatFunctions: chatFunctions,
                  );
                } else if (state is ChatErrorScreen) {
                  return CustomErrorScreen(
                      callBack: () => context.read<ChatBloc>().add(ChatStart()),
                      errorMessage: state.errorMessage);
                }
                return Container();
              },
            ),
          )),
    );
  }
}

// The Chat screen's duplicate frame
Widget _chatDuplicateFrame({required List<Widget> children}) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: Column(children: children),
  );
}

// The Chat screen's main widget
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
    return _chatDuplicateFrame(
      children: [
        // Chat messages part
        _MainPart(
          messagesList: messagesList,
          chatFunctions: chatFunctions,
          messagesFunctions: messagesFunctions,
        ),
        // Chat message sender part
        _BottomPart(
          senderController: senderController,
          roomIdRequirements: roomIdRequirements,
          chatFunctions: chatFunctions,
        ),
      ],
    );
  }
}

// The Chat screen's empty message widget
class _EmptyChatWidget extends StatelessWidget {
  const _EmptyChatWidget({
    required this.senderController,
    required this.roomIdRequirements,
    required this.chatFunctions,
  });
  final MessageSenderController senderController;
  final RoomIdRequirements roomIdRequirements;
  final ChatFunctions chatFunctions;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return _chatDuplicateFrame(children: [
      // Empty message dialog
      Flexible(
        flex: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Get.width * 0.7,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: colorScheme.primary,
              ),
              child: Text(
                emptyChatDialog,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.background,
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
          ],
        ),
      ),
      // Chat message sender part
      _BottomPart(
        senderController: senderController,
        roomIdRequirements: roomIdRequirements,
        chatFunctions: chatFunctions,
      ),
    ]);
  }
}

// The Chat screen's main part
class _MainPart extends StatelessWidget {
  const _MainPart({
    required this.messagesList,
    required this.messagesFunctions,
    required this.chatFunctions,
  });

  final List<MessageEntity> messagesList;
  final ChatFunctions chatFunctions;
  final MessagesFunctions messagesFunctions;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        reverse: true,
        itemCount: messagesList.length,
        itemBuilder: (context, index) {
          final MessageEntity messageEntity = messagesList[index];
          return GestureDetector(
            onLongPress: () async => chatFunctions.deleteChatMessageDialog(
                messageEntity: messageEntity),
            child: Builder(
              builder: (context) {
                switch (messageEntity.messageType) {
                  case MessageType.txt:
                    return TexetMessageScreen(
                      messageEntity: messageEntity,
                      messagesFunctions: messagesFunctions,
                    );
                  case MessageType.image:
                    return ImageMessageScreen(
                        key: Key(messageEntity.id),
                        messageEntity: messageEntity,
                        messagesFunctions: messagesFunctions);
                  case MessageType.other:
                    return OthetMessagesScreen(
                        messageEntity: messageEntity,
                        key: Key(messageEntity.id));
                }
              },
            ),
          );
        },
      ),
    );
  }
}

// The Chat screen's bottom part (Message sender part)
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
          _SenderTextField(roomIdRequirements: roomIdRequirements),
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

// Chat's message sender text field
class _SenderTextField extends StatelessWidget {
  _SenderTextField({required this.roomIdRequirements});

  final DependencyController dependencyController = Get.find();
  final MessageSenderController senderController = Get.find();
  late final ChatFunctions chatFunctions =
      dependencyController.appFunctions.chatFunctions;
  final RoomIdRequirements roomIdRequirements;
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
              hintText: typeMessageDialog,
              hintStyle: textTheme.bodySmall,
              prefixIcon: _SendImageAndFileButton(
                chatFunctions: chatFunctions,
                roomIdRequirements: roomIdRequirements,
              ),
              border: InputBorder.none),
        ),
      ),
    );
  }
}

// Chat's image and file message sender part
class _SendImageAndFileButton extends StatelessWidget {
  const _SendImageAndFileButton(
      {required this.chatFunctions, required this.roomIdRequirements});
  final ChatFunctions chatFunctions;
  final RoomIdRequirements roomIdRequirements;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return CupertinoButton(
      onPressed: () {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text(
                selectMessageTypeDialog,
                style:
                    textTheme.bodyLarge?.copyWith(color: colorScheme.primary),
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // File message sender button
                  senderButton(
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    iconData: fileIcon,
                    label: fileMessageDialog,
                    onPressed: () async => await chatFunctions.startFileSending(
                        roomIdRequirements: roomIdRequirements),
                  ),
                  // Image message sender button
                  senderButton(
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    iconData: imageIcon,
                    label: imageMessageDialog,
                    onPressed: () async {
                      await chatFunctions.startImageSending(
                          roomIdRequirements: roomIdRequirements);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Icon(
        paperClipIcon,
        color: colorScheme.primary,
      ),
    );
  }

  ElevatedButton senderButton(
      {required ColorScheme colorScheme,
      required TextTheme textTheme,
      required void Function()? onPressed,
      required IconData iconData,
      required String label}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(iconData, color: colorScheme.primary),
      label: Text(
        label,
        style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
      ),
    );
  }
}

// Chat screen's voice & text message sender part
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
                onPressed: () async => await chatFunctions.startRecording(
                  roomIdRequirements: roomIdRequirements,
                  colorScheme: colorScheme,
                ),
                icon: Icon(microphoneIcon, color: colorScheme.background),
              );
      },
    );
  }
}
