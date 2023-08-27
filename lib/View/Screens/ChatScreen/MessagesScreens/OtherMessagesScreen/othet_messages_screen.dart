import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          } else if (state is MessageFileLoadingScreen) {
            return _FileDownloadingStatusScreen(
              messageEntity: state.messageEntity,
              messagesFunctions: state.messagesFunctions,
              statusWidget: LoadingWidget(widgetSize: Get.width * 0.1),
            );
          } else if (state is MessageFileDownloadingScreen) {
            return _FileDownloadingStatusScreen(
              messageEntity: state.messageEntity,
              messagesFunctions: state.messagesFunctions,
              statusWidget: CustomProgressIndicator(
                downloadProgressStatus: state.downloadProgressStatus,
                messageEntity: messageEntity,
                onCancelTapped: () => context
                    .read<OtherMessagesBloc>()
                    .add(OtherMessagesCancelDownloading(messageEntity)),
                messagesFunctions: state.messagesFunctions,
              ),
            );
          } else if (state is MessageFileErrorScreen) {
            return _FileDownloadingStatusScreen(
              messageEntity: state.messageEntity,
              messagesFunctions: state.messagesFunctions,
              statusWidget: IconButton.filled(
                onPressed: () => context
                    .read<OtherMessagesBloc>()
                    .add(OtherMessagesStart(messageEntity)),
                icon: const Icon(errorIcon),
              ),
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

class _FileDownloadingStatusScreen extends StatelessWidget {
  const _FileDownloadingStatusScreen({
    required this.messageEntity,
    required this.messagesFunctions,
    required this.statusWidget,
  });
  final MessageEntity messageEntity;
  final MessagesFunctions messagesFunctions;
  final Widget statusWidget;
  @override
  Widget build(BuildContext context) {
    return MessageBox(
      messageEntity: messageEntity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          statusWidget,
          _FileTitle(
            messagesFunctions: messagesFunctions,
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
