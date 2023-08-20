import 'package:flutter/material.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/chat_function.dart';
import 'package:get/get.dart';

// TODO get chat functions from parent widget
class TexetMessageScreen extends StatelessWidget {
  TexetMessageScreen({super.key, required this.messageEntity});
  final MessageEntity messageEntity;
  late final DependencyController dependencyController = Get.find();
  late final ChatFunctions chatFunctions =
      dependencyController.appFunctions.chatFunctions;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return MessageBox(
      messageEntity: messageEntity,
      child: chatFunctions.buildCustomTextWidget(
        textTheme: textTheme,
        messageEntity: messageEntity,
        text: messageEntity.message,
        colorScheme: colorScheme,
      ),
    );
  }
}
