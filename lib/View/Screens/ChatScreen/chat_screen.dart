import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/ChatBloc/chat_bloc.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/MessagesScreens/ImageMessageScreen/image_message_screen.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/MessagesScreens/OtherMessagesScreen/othet_messages_screen.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/MessagesScreens/TextMessageScreen/text_message_screen.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/chat_function.dart';
import 'package:get/get.dart';

class ChatScteen extends StatelessWidget {
  ChatScteen({super.key, required this.senderUser, required this.receiverUser});
  final AppUser senderUser;
  final AppUser receiverUser;
  final DependencyController dependencyController = Get.find();
  late final ChatFunctions chatFunctions =
      dependencyController.appFunctions.chatFunctions;
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar( 
        forceMaterialTransparency: true,
        centerTitle: true,
        title: Text(
          chatFunctions.fechChatScreenTitle(
            senderUser: senderUser,
            receiverUser: receiverUser,
          ),
          style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700),
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
              final List<MessageEntity> messagesList = state.messagesList;
              return Padding(
                padding: const EdgeInsets.all(12),
                child: ListView.builder(
                  reverse: true,
                  itemCount: messagesList.length,
                  itemBuilder: (context, index) {
                    final MessageEntity messageEntity = messagesList[index];
                    switch (messageEntity.messageType) {
                      case MessageType.txt:
                        return TexetMessageScreen(messageEntity: messageEntity);
                      case MessageType.image:
                        return ImageMessageScreen(messageEntity: messageEntity);
                      case MessageType.other:
                        return OthetMessagesScreen(
                          messageEntity: messageEntity,
                        );
                    }
                  },
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
