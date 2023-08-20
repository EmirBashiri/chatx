import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/MessagesScreens/OtherMessagesScreen/bloc/other_messages_bloc.dart';
import 'package:flutter_chatx/View/Theme/icons.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/chat_function.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class OthetMessagesScreen extends StatelessWidget {
  const OthetMessagesScreen({super.key, required this.messageEntity});
  final MessageEntity messageEntity;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = OtherMessagesBloc();
        bloc.add(OtherMessagesStart(messageEntity));
        // _otherMessagesBloc = bloc;
        return bloc;
      },
      child: BlocBuilder<OtherMessagesBloc, OtherMessagesState>(
        builder: (context, state) {
          if (state is MessagesPervirewScreen) {
            return _FilePerviewScreen(
              messageEntity: state.messageEntity,
              chatFunctions: state.chatFunctions,
            );
          } else if (state is MessageFileDownloadingScreen) {
            return _FileLoadingScreen(
              messageEntity: state.messageEntity,
              chatFunctions: state.chatFunctions,
            );
          } else if (state is MessageFileReadyScreen) {
            return _FileReadyScreen(
              messageEntity: state.messageEntity,
              chatFunctions: state.chatFunctions,
            );
          }
          return Container();
        },
      ),
    );
  }
}

class _FileTitle extends StatelessWidget {
  const _FileTitle({required this.chatFunctions, required this.messageEntity});

  final ChatFunctions chatFunctions;
  final MessageEntity messageEntity;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Flexible(
      child: chatFunctions.buildCustomTextWidget(
        textTheme: textTheme,
        messageEntity: messageEntity,
        text: chatFunctions.fechFileMessageTitle(
          messageUrl: messageEntity.message,
        ),
        colorScheme: colorScheme,
      ),
    );
  }
}

class _FilePerviewScreen extends StatelessWidget {
  const _FilePerviewScreen({
    required this.messageEntity,
    required this.chatFunctions,
  });

  final MessageEntity messageEntity;
  final ChatFunctions chatFunctions;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context
          .read<OtherMessagesBloc>()
          .add(OtherMessagesDownloadFile(messageEntity)),
      child: MessageBox(
        messageEntity: messageEntity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              backgroundColor: colorScheme.primary,
              child: Icon(
                downloadIcon,
                color: colorScheme.background,
              ),
            ),
            _FileTitle(
              chatFunctions: chatFunctions,
              messageEntity: messageEntity,
            )
          ],
        ),
      ),
    );
  }
}

class _FileLoadingScreen extends StatelessWidget {
  const _FileLoadingScreen({
    required this.messageEntity,
    required this.chatFunctions,
  });
  final MessageEntity messageEntity;
  final ChatFunctions chatFunctions;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return MessageBox(
      messageEntity: messageEntity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StreamBuilder(
            stream: chatFunctions.downloadFile(fileUrl: messageEntity.message),
            builder: (context, snapshot) {
              if (snapshot.data is DownloadProgress) {
                final DownloadProgress downloadProgress =
                    snapshot.data as DownloadProgress;
                return CircularPercentIndicator(
                  // TODO clean here
                  radius: 60,
                  lineWidth: 5,
                  percent: downloadProgress.progress!,
                  center: Text("${downloadProgress.downloaded}"),
                );
              } else {
                return CircleAvatar(
                  backgroundColor: colorScheme.primary,
                  child: Icon(
                    downloadIcon,
                    color: colorScheme.background,
                  ),
                );
              }
            },
          ),
          _FileTitle(
            chatFunctions: chatFunctions,
            messageEntity: messageEntity,
          )
        ],
      ),
    );
  }
}

class _FileReadyScreen extends StatelessWidget {
  const _FileReadyScreen({
    required this.messageEntity,
    required this.chatFunctions,
  });

  final MessageEntity messageEntity;
  final ChatFunctions chatFunctions;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context
          .read<OtherMessagesBloc>()
          .add(OtherMessagesOpenFile(messageEntity)),
      child: MessageBox(
        messageEntity: messageEntity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              backgroundColor: colorScheme.primary,
              child: Icon(
                fileIcon,
                color: colorScheme.background,
              ),
            ),
            _FileTitle(
              chatFunctions: chatFunctions,
              messageEntity: messageEntity,
            )
          ],
        ),
      ),
    );
  }
}
