import 'package:flutter/material.dart';
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
