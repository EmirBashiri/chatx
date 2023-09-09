import 'dart:io';
import 'package:blur/blur.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/Model/Entities/duplicate_entities.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/View/Screens/ChatScreen/MessagesScreens/ImageMessageScreen/bloc/image_message_bloc.dart';
import 'package:flutter_chatx/View/Theme/icons.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/messages_funtions.dart';

const double duplicateHeight = 120;

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
    return BlocProvider(
      create: (context) {
        final bloc = ImageMessageBloc();
        bloc.add(ImageMessageStart(messageEntity));
        return bloc;
      },
      child: BlocBuilder<ImageMessageBloc, ImageMessageState>(
        builder: (context, state) {
          if (state is ImageMessagePerviewScreen) {
            return _ImagePerviewScreen(messageEntity: messageEntity);
          } else if (state is ImageMessageLoadingScreen) {
            return _ImageLoadingScreen(messageEntity: messageEntity);
          } else if (state is ImageMessageUoloadProgressScreen) {
            return _ImageMessageUploadProgressScreen(
              messageEntity: messageEntity,
              operationProgress: state.operationProgress,
              imageFile: state.imageFile,
              messagesFunctions: messagesFunctions,
            );
          } else if (state is ImageMessageDownloadProgressScreen) {
            return _ImageMessageDownloadProgressScreen(
              messageEntity: messageEntity,
              operationProgress: state.operationProgress,
              messagesFunctions: messagesFunctions,
            );
          } else if (state is ImageMessageReadyScreen) {
            return _ImageMessageReadyScreen(
              messageEntity: messageEntity,
              imageFile: state.imageFile,
              messagesFunctions: messagesFunctions,
            );
          } else if (state is ImageMessageUploadErrorScreen) {
            return _ImageMessageUploadErrorScreen(
                messageEntity: messageEntity, imageFile: state.imageFile);
          } else if (state is ImageMessageDownloadErrorScreen) {
            return _ImageMessageDownloadErrorScreen(
                messageEntity: messageEntity);
          }
          return Container();
        },
      ),
    );
  }
}

class _ImagePerviewScreen extends StatelessWidget {
  const _ImagePerviewScreen({
    required this.messageEntity,
  });

  final MessageEntity messageEntity;

  @override
  Widget build(BuildContext context) {
    return _DuplicateFrame(
      messageEntity: messageEntity,
      height: duplicateHeight,
      child: IconButton(
        onPressed: () => context
            .read<ImageMessageBloc>()
            .add(ImageMessageStartDownload(messageEntity)),
        icon: const CustomIcon(iconData: downloadIcon),
      ),
    );
  }
}

class _ImageLoadingScreen extends StatelessWidget {
  const _ImageLoadingScreen({required this.messageEntity});

  final MessageEntity messageEntity;

  @override
  Widget build(BuildContext context) {
    return _DuplicateFrame(
        height: duplicateHeight,
        messageEntity: messageEntity,
        child: const LoadingWidget());
  }
}

class _ImageMessageUploadProgressScreen extends StatelessWidget {
  const _ImageMessageUploadProgressScreen(
      {required this.messageEntity,
      required this.operationProgress,
      this.imageFile,
      required this.messagesFunctions});

  final MessageEntity messageEntity;
  final OperationProgress operationProgress;
  final MessagesFunctions messagesFunctions;
  final File? imageFile;

  @override
  Widget build(BuildContext context) {
    return _DuplicateFrame(
      messageEntity: messageEntity,
      child: _BuildImageWithChild(
        imageFile: imageFile,
        child: CustomProgressIndicator(
          operationProgress: operationProgress,
          messageEntity: messageEntity,
          onCancelTapped: () => context
              .read<ImageMessageBloc>()
              .add(ImageMessageCancelUpload(messageEntity)),
          messagesFunctions: messagesFunctions,
        ),
      ),
    );
  }
}

class _ImageMessageDownloadProgressScreen extends StatelessWidget {
  const _ImageMessageDownloadProgressScreen(
      {required this.messageEntity,
      required this.operationProgress,
      required this.messagesFunctions});

  final MessageEntity messageEntity;
  final OperationProgress operationProgress;
  final MessagesFunctions messagesFunctions;

  @override
  Widget build(BuildContext context) {
    return _DuplicateFrame(
      messageEntity: messageEntity,
      height: duplicateHeight,
      child: _CustomPlaceholder(
        child: CustomProgressIndicator(
            operationProgress: operationProgress,
            messageEntity: messageEntity,
            onCancelTapped: () => context
                .read<ImageMessageBloc>()
                .add(ImageMessageCancelDownload(messageEntity)),
            messagesFunctions: messagesFunctions),
      ),
    );
  }
}

class _ImageMessageReadyScreen extends StatelessWidget {
  const _ImageMessageReadyScreen(
      {required this.messageEntity,
      required this.imageFile,
      required this.messagesFunctions});

  final MessageEntity messageEntity;
  final MessagesFunctions messagesFunctions;
  final File imageFile;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async =>
          await messagesFunctions.openImage(messageEntity: messageEntity),
      child: _DuplicateFrame(
        messageEntity: messageEntity,
        child: _DuplicateFileImage(imageFile: imageFile),
      ),
    );
  }
}

class _ImageMessageUploadErrorScreen extends StatelessWidget {
  const _ImageMessageUploadErrorScreen(
      {required this.messageEntity, this.imageFile});

  final MessageEntity messageEntity;
  final File? imageFile;

  @override
  Widget build(BuildContext context) {
    return _DuplicateFrame(
        messageEntity: messageEntity,
        height: imageFile == null ? duplicateHeight : null,
        child: _BuildImageWithChild(
          imageFile: imageFile,
          child: IconButton(
            onPressed: () => context
                .read<ImageMessageBloc>()
                .add(ImageMessageDeleteErroredImage(messageEntity)),
            icon: const CustomIcon(iconData: errorIcon),
          ),
        ));
  }
}

class _ImageMessageDownloadErrorScreen extends StatelessWidget {
  const _ImageMessageDownloadErrorScreen({required this.messageEntity});

  final MessageEntity messageEntity;

  @override
  Widget build(BuildContext context) {
    return _DuplicateFrame(
      messageEntity: messageEntity,
      height: duplicateHeight,
      child: IconButton(
        onPressed: () => context
            .read<ImageMessageBloc>()
            .add(ImageMessageStart(messageEntity)),
        icon: const CustomIcon(iconData: errorIcon),
      ),
    );
  }
}

class _BuildImageWithChild extends StatelessWidget {
  final File? imageFile;
  final Widget child;

  const _BuildImageWithChild({this.imageFile, required this.child});
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    // Here checking if image file is null or not
    return imageFile != null
        // if image file is not null a blurred image widget with progress child will return
        ? ExtendedImage.file(imageFile!).blurred(
            blurColor: colorScheme.secondary,
            colorOpacity: 0.25,
            overlay: _CustomPlaceholder(child: child),
          )
        // if image file is null single child will return
        : child;
  }
}

class _CustomPlaceholder extends StatelessWidget {
  const _CustomPlaceholder({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
          color: colorScheme.primaryContainer, shape: BoxShape.circle),
      child: child,
    );
  }
}

class _DuplicateFileImage extends StatelessWidget {
  const _DuplicateFileImage({
    required this.imageFile,
  });

  final File? imageFile;

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.file(imageFile!);
  }
}

class _DuplicateFrame extends StatelessWidget {
  const _DuplicateFrame(
      {required this.child, required this.messageEntity, this.height});
  final MessageEntity messageEntity;
  final Widget child;
  final double? height;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return MessageBox(
      messageEntity: messageEntity,
      child: Container(
        color: colorScheme.secondary,
        height: height,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
