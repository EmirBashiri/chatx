import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/View/Theme/icons.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/messages_funtions.dart';
import 'package:get/get.dart';

import 'bloc/other_messages_bloc.dart';

class OthetMessagesWidget extends StatefulWidget {
  const OthetMessagesWidget({super.key, required this.messageEntity});
  final MessageEntity messageEntity;

  @override
  State<OthetMessagesWidget> createState() => _OthetMessagesWidgetState();
}

class _OthetMessagesWidgetState extends State<OthetMessagesWidget>
    with AutomaticKeepAliveClientMixin {
  final MessagesFunctions messagesFunctions =
      Get.find<DependencyController>().appFunctions.messagesFunctions;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RepaintBoundary(
      child: BlocProvider(
        create: (context) {
          final bloc = OtherMessagesBloc();
          bloc.add(OtherMessagesStart(widget.messageEntity));
          return bloc;
        },
        child: BlocBuilder<OtherMessagesBloc, OtherMessagesState>(
          builder: (context, state) {
            if (state is MessagesPervirewState) {
              return _FilePerviewState(
                messageEntity: widget.messageEntity,
                messagesFunctions: messagesFunctions,
              );
            } else if (state is MessageFileLoadingState) {
              return _FileOperationState(
                messageEntity: widget.messageEntity,
                messagesFunctions: messagesFunctions,
                statusWidget: LoadingWidget(widgetSize: Get.width * 0.1),
              );
            } else if (state is MessageFileDownloadingState) {
              return _FileOperationState(
                messageEntity: widget.messageEntity,
                messagesFunctions: messagesFunctions,
                statusWidget: CustomProgressIndicator(
                  operationProgress: state.operationProgress,
                  messageEntity: widget.messageEntity,
                  onCancelTapped: () => context.read<OtherMessagesBloc>().add(
                      OtherMessagesCancelDownloading(widget.messageEntity)),
                  messagesFunctions: messagesFunctions,
                ),
              );
            } else if (state is MessageFileUploadingStatusState) {
              return _FileOperationState(
                messageEntity: widget.messageEntity,
                messagesFunctions: messagesFunctions,
                statusWidget: CustomProgressIndicator(
                  operationProgress: state.operationProgress,
                  messageEntity: widget.messageEntity,
                  onCancelTapped: () => context
                      .read<OtherMessagesBloc>()
                      .add(OtherMessagesCancelUploading(widget.messageEntity)),
                  messagesFunctions: messagesFunctions,
                ),
              );
            } else if (state is MessageFileDownloadErrorState) {
              return _FileOperationState(
                messageEntity: widget.messageEntity,
                messagesFunctions: messagesFunctions,
                statusWidget: IconButton.filled(
                  onPressed: () => context
                      .read<OtherMessagesBloc>()
                      .add(OtherMessagesStart(widget.messageEntity)),
                  icon: const Icon(errorIcon),
                ),
              );
            } else if (state is MessageFileUploadErrorState) {
              return _FileOperationState(
                messageEntity: widget.messageEntity,
                messagesFunctions: messagesFunctions,
                statusWidget: IconButton.filled(
                  onPressed: () => context.read<OtherMessagesBloc>().add(
                      OtherMessagesDeleteErroredFile(widget.messageEntity)),
                  icon: const Icon(errorIcon),
                ),
              );
            } else if (state is MessageFileReadyState) {
              return _FileReadyState(
                messageEntity: widget.messageEntity,
                messagesFunctions: messagesFunctions,
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
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
    final String messageFileTitle =
        messagesFunctions.fechFileMessageTitle(messageEntity: messageEntity);
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

class _FilePerviewState extends StatelessWidget {
  const _FilePerviewState({
    required this.messageEntity,
    required this.messagesFunctions,
  });

  final MessageEntity messageEntity;
  final MessagesFunctions messagesFunctions;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context
          .read<OtherMessagesBloc>()
          .add(OtherMessagesDownloadFile(messageEntity)),
      child: MessageBox(
        messageEntity: messageEntity,
        child: _duplocateFrame(
          icon: const CustomIcon(iconData: downloadIcon),
          messageEntity: messageEntity,
          messagesFunctions: messagesFunctions,
        ),
      ),
    );
  }
}

class _FileOperationState extends StatelessWidget {
  const _FileOperationState({
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
      child: _duplocateFrame(
        icon: statusWidget,
        messageEntity: messageEntity,
        messagesFunctions: messagesFunctions,
      ),
    );
  }
}

class _FileReadyState extends StatelessWidget {
  const _FileReadyState({
    required this.messageEntity,
    required this.messagesFunctions,
  });

  final MessageEntity messageEntity;
  final MessagesFunctions messagesFunctions;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context
          .read<OtherMessagesBloc>()
          .add(OtherMessagesOpenFile(messageEntity)),
      child: MessageBox(
        messageEntity: messageEntity,
        child: _duplocateFrame(
          icon: const CustomIcon(iconData: fileIcon),
          messageEntity: messageEntity,
          messagesFunctions: messagesFunctions,
        ),
      ),
    );
  }
}

Row _duplocateFrame({
  required Widget icon,
  required MessageEntity messageEntity,
  required MessagesFunctions messagesFunctions,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Padding(padding: const EdgeInsets.only(right: 10), child: icon),
      _FileTitle(
        messagesFunctions: messagesFunctions,
        messageEntity: messageEntity,
      ),
    ],
  );
}
