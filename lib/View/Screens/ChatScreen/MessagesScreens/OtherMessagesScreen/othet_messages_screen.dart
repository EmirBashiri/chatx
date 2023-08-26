import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/MessagesScreens/OtherMessagesScreen/bloc/other_messages_bloc.dart';
import 'package:flutter_chatx/View/Theme/icons.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/messages_funtions.dart';
import 'package:get/get.dart';

class OthetMessagesScreen extends StatelessWidget {
  const OthetMessagesScreen({super.key, required this.messageEntity});
  final MessageEntity messageEntity;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = OtherMessagesBloc();
        bloc.add(OtherMessagesStart(messageEntity));
        return bloc;
      },
      child: BlocBuilder<OtherMessagesBloc, OtherMessagesState>(
        builder: (context, state) {
          if (state is MessagesPervirewScreen) {
            return _FilePerviewScreen(
              messageEntity: state.messageEntity,
              messagesFunctions: state.messagesFunctions,
            );
          } else if (state is MessageFileDownloadingScreen) {
            return _FileLoadingScreen(
              messageEntity: state.messageEntity,
              messagesFunctions: state.messagesFunctions,
            );
          } else if (state is MessageFileReadyScreen) {
            return _FileReadyScreen(
              messageEntity: state.messageEntity,
              messagesFunctions: state.messagesFunctions,
            );
          }
          return Container();
        },
      ),
    );
  }
}

class _FileTitle extends StatelessWidget {
  const _FileTitle(
      {required this.messagesFunctions, required this.messageEntity});

  final MessagesFunctions messagesFunctions;
  final MessageEntity messageEntity;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Flexible(
      child: textWidget(
        textTheme: textTheme,
        colorScheme: colorScheme,
      ),
    );
  }

  Text textWidget(
      {required TextTheme textTheme, required ColorScheme colorScheme}) {
    final String messageFileTitle = messagesFunctions.fechFileMessageTitle(
        messageUrl: messageEntity.message);
    return messagesFunctions.senderIsCurrentUser(messageEntity: messageEntity)
        ? Text(
            messageFileTitle,
            style: textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.secondary,
            ),
          )
        : Text(
            messageFileTitle,
            style: textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.background,
            ),
          );
  }
}

class _FilePerviewScreen extends StatelessWidget {
  const _FilePerviewScreen({
    required this.messageEntity,
    required this.messagesFunctions,
  });

  final MessageEntity messageEntity;
  final MessagesFunctions messagesFunctions;

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
              messagesFunctions: messagesFunctions,
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
    required this.messagesFunctions,
  });
  final MessageEntity messageEntity;
  final MessagesFunctions messagesFunctions;

  @override
  Widget build(BuildContext context) {
    return MessageBox(
      messageEntity: messageEntity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _CustomStreamBuilder(
            messagesFunctions: messagesFunctions,
            messageEntity: messageEntity,
          ),
          _FileTitle(
            messagesFunctions: messagesFunctions,
            messageEntity: messageEntity,
          )
        ],
      ),
    );
  }
}

class _CustomStreamBuilder extends StatelessWidget {
  const _CustomStreamBuilder({
    required this.messagesFunctions,
    required this.messageEntity,
  });

  final MessagesFunctions messagesFunctions;
  final MessageEntity messageEntity;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: messagesFunctions.downloadFile(
        messageEntity: messageEntity,
        otherMessagesBloc: context.read<OtherMessagesBloc>(),
      ),
      builder: (context, snapshot) {
        if (snapshot.data is DownloadProgress) {
          final DownloadProgress downloadProgress =
              snapshot.data as DownloadProgress;
          return CustomProgressIndicator(
            downloadProgress: downloadProgress,
            messageEntity: messageEntity,
            onCancelTapped: () => context
                .read<OtherMessagesBloc>()
                .add(OtherMessagesCancelDownloadin(messageEntity)),
          );
        } else if (snapshot.hasError) {
          return IconButton.filled(
              onPressed: () => context
                  .read<OtherMessagesBloc>()
                  .add(OtherMessagesStart(messageEntity)),
              icon: const Icon(errorIcon));
        } else {
          return LoadingWidget(widgetSize: Get.width * 0.1);
        }
      },
    );
  }
}

class _FileReadyScreen extends StatelessWidget {
  const _FileReadyScreen({
    required this.messageEntity,
    required this.messagesFunctions,
  });

  final MessageEntity messageEntity;
  final MessagesFunctions messagesFunctions;

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
              messagesFunctions: messagesFunctions,
              messageEntity: messageEntity,
            )
          ],
        ),
      ),
    );
  }
}
