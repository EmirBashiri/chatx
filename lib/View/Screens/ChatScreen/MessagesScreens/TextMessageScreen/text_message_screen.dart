import 'package:flutter/material.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/messages_funtions.dart';

class TexetMessageScreen extends StatefulWidget {
  const TexetMessageScreen(
      {super.key,
      required this.messageEntity,
      required this.messagesFunctions});
  final MessageEntity messageEntity;
  final MessagesFunctions messagesFunctions;

  @override
  State<TexetMessageScreen> createState() => _TexetMessageScreenState();
}

class _TexetMessageScreenState extends State<TexetMessageScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return MessageBox(
      messageEntity: widget.messageEntity,
      child: textWidget(
        textTheme: textTheme,
        colorScheme: colorScheme,
      ),
    );
  }

  Text textWidget(
      {required TextTheme textTheme, required ColorScheme colorScheme}) {
    return widget.messagesFunctions
            .senderIsCurrentUser(messageEntity: widget.messageEntity)
        ? Text(
            widget.messageEntity.messageContent,
            style: textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.secondary,
            ),
          )
        : Text(
            widget.messageEntity.messageContent,
            style: textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.background,
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
