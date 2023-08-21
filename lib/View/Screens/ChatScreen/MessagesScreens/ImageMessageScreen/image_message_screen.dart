import 'package:flutter/material.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/messages_funtions.dart';

class ImageMessageScreen extends StatelessWidget {
  const ImageMessageScreen({
    super.key,
    required this.messageEntity,
    required this.messagesFunctions,
  });

  final MessageEntity messageEntity;
  final MessagesFunctions messagesFunctions;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async =>
          await messagesFunctions.openImage(messageEntity: messageEntity),
      child: MessageBox(
        messageEntity: messageEntity,
        child: CustomImageWidget(imageUrl: messageEntity.message),
      ),
    );
  }
}
