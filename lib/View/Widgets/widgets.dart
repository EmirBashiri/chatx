import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/message_entiry.dart';
import 'package:flutter_chatx/View/Theme/icons.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/ChatFunctions/messages_funtions.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.backgroundColor,
      required this.title,
      required this.onPressed,
      this.suffixIcon,
      this.titleStyle});
  final Color backgroundColor;
  final String title;
  final TextStyle? titleStyle;
  final void Function() onPressed;
  final Widget? suffixIcon;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      width: Get.width,
      height: 80,
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        icon: suffixIcon ?? Container(),
        label: Text(
          title,
          style: titleStyle ??
              textTheme.headlineSmall!.copyWith(color: colorScheme.primary),
        ),
      ),
    );
  }
}

void showSnakeBar({
  required String title,
  required String message,
  Color? backgroundColor,
}) {
  final ColorScheme colorScheme = Get.theme.colorScheme;
  Get.closeAllSnackbars();
  Get.snackbar(
    title,
    message,
    backgroundColor: backgroundColor ?? colorScheme.primaryContainer,
  );
}

class CustomLoadingScreen extends StatelessWidget {
  const CustomLoadingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Center(
        child: SpinKitPianoWave(color: colorScheme.primary),
      ),
    );
  }
}

class CustomErrorScreen extends StatelessWidget {
  const CustomErrorScreen({
    super.key,
    required this.callBack,
    required this.errorMessage,
  });

  final void Function() callBack;
  final String errorMessage;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constrain) {
                      return Container(
                        width: constrain.maxWidth,
                        height: constrain.maxHeight * 0.6,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.error.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: colorScheme.error,
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  errorMessage,
                                  style: textTheme.bodyMedium,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary),
                onPressed: callBack,
                child: Text(
                  tryAgain,
                  style: textTheme.bodyMedium!.copyWith(
                    color: colorScheme.background,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomImageWidget extends StatelessWidget {
  const CustomImageWidget({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      imageUrl,
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return const LoadingWidget();

          default:
            return state.completedWidget;
        }
      },
    );
  }
}

ExtendedNetworkImageProvider networkImageProvider({required String imageUr}) {
  return ExtendedNetworkImageProvider(imageUr, cache: true);
}

// This widgest are blong to chat screen
class MessageBox extends StatelessWidget {
  MessageBox({super.key, required this.messageEntity, required this.child});
  final MessageEntity messageEntity;
  final Widget child;

  final DependencyController dependencyController = Get.find();
  late final MessagesFunctions messagesFunctions =
      dependencyController.appFunctions.messagesFunctions;

  @override
  Widget build(BuildContext context) {
    return messagesFunctions.senderIsCurrentUser(messageEntity: messageEntity)
        ? _SenderIsCurrentUserBox(
            messagesFunctions: messagesFunctions,
            messageEntity: messageEntity,
            child: child,
          )
        : _ReceiverIsCurrentUserBox(
            messagesFunctions: messagesFunctions,
            messageEntity: messageEntity,
            child: child,
          );
  }
}

class _SenderIsCurrentUserBox extends StatelessWidget {
  const _SenderIsCurrentUserBox({
    required this.messagesFunctions,
    required this.messageEntity,
    required this.child,
  });
  final MessagesFunctions messagesFunctions;
  final MessageEntity messageEntity;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    const Radius duplicateRadius = Radius.circular(12);

    return _AlignedWidgets(
      messagesFunctions: messagesFunctions,
      messageEntity: messageEntity,
      boxRadius: const BorderRadiusDirectional.only(
        topStart: duplicateRadius,
        topEnd: duplicateRadius,
        bottomStart: duplicateRadius,
      ),
      boxAlignment: Alignment.bottomRight,
      boxColor: colorScheme.primaryContainer,
      chlidrenAlignment: CrossAxisAlignment.start,
      textsColor: colorScheme.secondary,
      child: child,
    );
  }
}

class _ReceiverIsCurrentUserBox extends StatelessWidget {
  const _ReceiverIsCurrentUserBox(
      {required this.messagesFunctions,
      required this.messageEntity,
      required this.child});
  final MessagesFunctions messagesFunctions;
  final MessageEntity messageEntity;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    const Radius duplicateRadius = Radius.circular(12);

    return _AlignedWidgets(
      messagesFunctions: messagesFunctions,
      messageEntity: messageEntity,
      boxRadius: const BorderRadiusDirectional.only(
        topStart: duplicateRadius,
        topEnd: duplicateRadius,
        bottomEnd: duplicateRadius,
      ),
      boxAlignment: Alignment.bottomLeft,
      boxColor: colorScheme.inversePrimary,
      chlidrenAlignment: CrossAxisAlignment.end,
      textsColor: colorScheme.background,
      child: child,
    );
  }
}

class _AlignedWidgets extends StatelessWidget {
  const _AlignedWidgets({
    required this.child,
    required this.messagesFunctions,
    required this.messageEntity,
    required this.boxRadius,
    required this.boxAlignment,
    required this.boxColor,
    required this.textsColor,
    required this.chlidrenAlignment,
  });
  final BorderRadiusGeometry boxRadius;
  final Widget child;
  final MessagesFunctions messagesFunctions;
  final Alignment boxAlignment;
  final MessageEntity messageEntity;
  final Color boxColor;
  final Color textsColor;
  final CrossAxisAlignment chlidrenAlignment;

  @override
  Widget build(BuildContext context) {
    const EdgeInsetsGeometry duplicatePadding = EdgeInsets.all(12);

    return Align(
      alignment: boxAlignment,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: Get.width * 0.65,
        ),
        margin: duplicatePadding,
        padding: duplicatePadding,
        decoration: BoxDecoration(
          borderRadius: boxRadius,
          color: boxColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: chlidrenAlignment,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: child,
            ),
            _TimeStampWidget(
              messagesFunctions: messagesFunctions,
              messageEntity: messageEntity,
              textColor: textsColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeStampWidget extends StatelessWidget {
  const _TimeStampWidget({
    required this.messagesFunctions,
    required this.messageEntity,
    required this.textColor,
  });

  final MessagesFunctions messagesFunctions;
  final MessageEntity messageEntity;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Text(
      messagesFunctions.messageTimeStamp(timestamp: messageEntity.timestamp),
      style: textTheme.labelSmall!.copyWith(
        color: textColor,
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.widgetColor, this.widgetSize});
  final Color? widgetColor;
  final double? widgetSize;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SpinKitPianoWave(
      color: widgetColor ?? colorScheme.primary,
      size: widgetSize ?? 50,
    );
  }
}

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({
    super.key,
    required this.downloadProgress,
    required this.messageEntity,
  });

  final DownloadProgress downloadProgress;
  final MessageEntity messageEntity;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return CircularPercentIndicator(
      progressColor: colorScheme.primary,
      radius: Get.width * 0.1,
      lineWidth: 5,
      percent: downloadProgress.progress!,
      center: Icon(
        downloadingIcon,
        color: colorScheme.primary,
      ),
    );
  }
}
