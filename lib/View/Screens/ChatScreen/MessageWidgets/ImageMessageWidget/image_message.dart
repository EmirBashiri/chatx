import 'dart:io';
import 'package:blur/blur.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/Model/Entities/duplicate_entities.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/View/Theme/icons.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/messages_funtions.dart';

import 'bloc/image_message_bloc.dart';

const double duplicateHeight = 120;

class ImageMessageWidget extends StatefulWidget {
  const ImageMessageWidget({
    super.key,
    required this.messageEntity,
    required this.messagesFunctions,
  });

  final MessageEntity messageEntity;
  final MessagesFunctions messagesFunctions;

  @override
  State<ImageMessageWidget> createState() => _ImageMessageWidgetState();
}

class _ImageMessageWidgetState extends State<ImageMessageWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) {
        final bloc = ImageMessageBloc();
        bloc.add(ImageMessageStart(widget.messageEntity));
        return bloc;
      },
      child: BlocBuilder<ImageMessageBloc, ImageMessageState>(
        builder: (context, state) {
          if (state is ImageMessagePerviewState) {
            return _ImagePerviewState(messageEntity: widget.messageEntity);
          } else if (state is ImageMessageLoadingState) {
            return _ImageLoadingState(messageEntity: widget.messageEntity);
          } else if (state is ImageMessageUoloadProgressState) {
            return _ImageMessageUploadProgressState(
              messageEntity: widget.messageEntity,
              operationProgress: state.operationProgress,
              imageFile: state.imageFile,
              messagesFunctions: widget.messagesFunctions,
            );
          } else if (state is ImageMessageDownloadProgressState) {
            return _ImageMessageDownloadProgressState(
              messageEntity: widget.messageEntity,
              operationProgress: state.operationProgress,
              messagesFunctions: widget.messagesFunctions,
            );
          } else if (state is ImageMessageReadyState) {
            return _ImageMessageReadyState(
              messageEntity: widget.messageEntity,
              imageFile: state.imageFile,
              messagesFunctions: widget.messagesFunctions,
            );
          } else if (state is ImageMessageUploadErrorState) {
            return _ImageMessageUploadErrorState(
                messageEntity: widget.messageEntity,
                imageFile: state.imageFile);
          } else if (state is ImageMessageDownloadErrorState) {
            return _ImageMessageDownloadErrorState(
                messageEntity: widget.messageEntity);
          }
          return Container();
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ImagePerviewState extends StatelessWidget {
  const _ImagePerviewState({
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

class _ImageLoadingState extends StatelessWidget {
  const _ImageLoadingState({required this.messageEntity});

  final MessageEntity messageEntity;

  @override
  Widget build(BuildContext context) {
    return _DuplicateFrame(
        height: duplicateHeight,
        messageEntity: messageEntity,
        child: const LoadingWidget());
  }
}

class _ImageMessageUploadProgressState extends StatelessWidget {
  const _ImageMessageUploadProgressState(
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

class _ImageMessageDownloadProgressState extends StatelessWidget {
  const _ImageMessageDownloadProgressState(
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

class _ImageMessageReadyState extends StatelessWidget {
  const _ImageMessageReadyState(
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

class _ImageMessageUploadErrorState extends StatelessWidget {
  const _ImageMessageUploadErrorState(
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

class _ImageMessageDownloadErrorState extends StatelessWidget {
  const _ImageMessageDownloadErrorState({required this.messageEntity});

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

// Custom image placeholder
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
