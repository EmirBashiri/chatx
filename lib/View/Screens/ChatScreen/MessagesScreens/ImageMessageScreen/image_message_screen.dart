import 'package:flutter/material.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';

class ImageMessageScreen extends StatelessWidget {
  const ImageMessageScreen({
    super.key,
    required this.messageEntity,
  });

  final MessageEntity messageEntity;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO implement open image functionality
      },
      child: MessageBox(
        messageEntity: messageEntity,
        child: CustomImageWidget(imageUrl: messageEntity.message),
      ),
    );
  }
}
