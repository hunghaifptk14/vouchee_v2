import 'package:flutter/material.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';

class BasicButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final double? font;
  const BasicButton(
      {super.key,
      required this.onPressed,
      required this.title,
      this.height,
      this.backgroundColor,
      required this.textColor,
      this.font});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(height ?? 50),
          backgroundColor: backgroundColor ?? AppColor.primary),
      onPressed: onPressed,
      child: Text(title,
          style: TextStyle(
            color: textColor ?? AppColor.white,
            fontSize: 14 ?? font,
          )),
    );
  }
}
