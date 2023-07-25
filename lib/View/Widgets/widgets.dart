import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.backgroundColor,
      required this.title,
      required this.onPressed});
  final Color backgroundColor;
  final String title;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      width: Get.width,
      height: 80,
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: textTheme.headlineSmall!.copyWith(color: colorScheme.primary),
        ),
      ),
    );
  }
}
