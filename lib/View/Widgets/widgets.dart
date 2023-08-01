import 'package:flutter/material.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

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
      body: Center(child: SpinKitPianoWave(color: colorScheme.primary)),
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
