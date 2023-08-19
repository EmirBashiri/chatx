import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/MessageBox/bloc/message_box_bloc.dart';
import 'package:flutter_chatx/View/Theme/icons.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/chat_function.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

// Instanse of Message box bloc for use in whole file
late MessageBoxBloc messageBoxBloc;

class MessageBoxScreen extends StatelessWidget {
  const MessageBoxScreen({super.key, required this.messageEntity});
  final MessageEntity messageEntity;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = MessageBoxBloc();
        bloc.add(MessageBoxStart(messageEntity));
        messageBoxBloc = bloc;
        return bloc;
      },
      child: const _MessageBoxMainScreen(),
    );
  }
}

class _MessageBoxMainScreen extends StatefulWidget {
  const _MessageBoxMainScreen();

  @override
  State<_MessageBoxMainScreen> createState() => _MessageBoxMainScreenState();
}

class _MessageBoxMainScreenState extends State<_MessageBoxMainScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void dispose() {
    super.dispose();
    messageBoxBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<MessageBoxBloc, MessageBoxState>(
      builder: (context, state) {
        if (state is MessageTextBox) {
          return _TexetMessage(messageEntity: state.messageEntity);
        } else if (state is MessageImageBox) {
          return _ImageMessage(
            messageEntity: state.messageEntity,
            onTap: () async {
              // TODO implement open image file here
            },
          );
        } else if (state is MessageFileBox) {
          return _FileMessage(messageEntity: state.messageEntity);
        } else if (state is MessageLoadingFileBox) {
          return _FileMessageLoading(messageEntity: state.messageEntity);
        }
        return Container();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _MessageBox extends StatelessWidget {
  _MessageBox({required this.messageEntity, required this.child});
  final MessageEntity messageEntity;
  final Widget child;
  final ColorScheme colorScheme = Get.theme.colorScheme;

  final DependencyController dependencyController = Get.find();

  late final ChatFunctions chatFunctions =
      dependencyController.appFunctions.chatFunctions;

  // Fech message align
  late final Alignment messageAlign = chatFunctions.fechMessageAlign(
    senderUserId: messageEntity.senderUserId,
  );

  // Fech message box border
  late final BorderRadiusGeometry boxBorderRadius =
      chatFunctions.fechMessageBorder(
    senderUserId: messageEntity.senderUserId,
  );

  // Fech message box color
  late final Color boxColor = chatFunctions.fechMessageBoxColor(
      senderUserId: messageEntity.senderUserId, colorScheme: colorScheme);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: messageAlign,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.45,
          maxWidth: Get.width * 0.65,
        ),
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: boxBorderRadius,
          color: boxColor,
        ),
        child: child,
      ),
    );
  }
}

class _TexetMessage extends StatelessWidget {
  _TexetMessage({required this.messageEntity});
  final MessageEntity messageEntity;
  late final DependencyController dependencyController = Get.find();
  late final ChatFunctions chatFunctions =
      dependencyController.appFunctions.chatFunctions;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return _MessageBox(
      messageEntity: messageEntity,
      child: chatFunctions.buildCustomTextWidget(
          textTheme: textTheme,
          messageEntity: messageEntity,
          text: messageEntity.message,
          colorScheme: colorScheme),
    );
  }
}

class _ImageMessage extends StatelessWidget {
  const _ImageMessage({
    required this.messageEntity,
    required this.onTap,
  });

  final MessageEntity messageEntity;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _MessageBox(
        messageEntity: messageEntity,
        child: CustomImageWidget(imageUrl: messageEntity.message),
      ),
    );
  }
}

class _FileMessage extends StatelessWidget {
  _FileMessage({required this.messageEntity});

  final MessageEntity messageEntity;
  late final DependencyController dependencyController = Get.find();
  late final ChatFunctions chatFunctions =
      dependencyController.appFunctions.chatFunctions;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        print(messageEntity);
        messageBoxBloc.add(MessageDownloadFile(messageEntity));
      },
      child: _MessageBox(
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
            Flexible(
              child: chatFunctions.buildCustomTextWidget(
                textTheme: textTheme,
                messageEntity: messageEntity,
                // TODO implement real name of file here
                text: "Song.mp3",
                colorScheme: colorScheme,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FileMessageLoading extends StatelessWidget {
  _FileMessageLoading({required this.messageEntity});
  final MessageEntity messageEntity;

  late final DependencyController dependencyController = Get.find();
  late final ChatFunctions chatFunctions =
      dependencyController.appFunctions.chatFunctions;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return _MessageBox(
      messageEntity: messageEntity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StreamBuilder(
            stream: chatFunctions.downloadFile(
              fileUrl: messageEntity.message,
              messageBoxBloc: messageBoxBloc,
            ),
            builder: (context, snapshot) {
              if (snapshot.data is DownloadProgress) {
                final DownloadProgress downloadProgress =
                    snapshot.data as DownloadProgress;
                return CircularPercentIndicator(
                  // TODO clean here
                  radius: 60,
                  lineWidth: 5,
                  percent: downloadProgress.progress!,
                  center: Text(
                      "${downloadProgress.downloaded}"),
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
          Flexible(
            child: chatFunctions.buildCustomTextWidget(
              textTheme: textTheme,
              messageEntity: messageEntity,
              // TODO implement real name of file here
              text: "Song.mp3",
              colorScheme: colorScheme,
            ),
          ),
        ],
      ),
    );
  }
}
