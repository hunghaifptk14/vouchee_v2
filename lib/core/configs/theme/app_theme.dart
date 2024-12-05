import 'package:flutter/material.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';

class AppTheme {
  static final lightTheme = ThemeData(
      // primaryColor: AppColor.primary,
      primaryColor: AppColor.primary,
      brightness: Brightness.light,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: const Color.fromARGB(255, 248, 248, 255),
      // scaffoldBackgroundColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.all(8),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.black, width: 0.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.black, width: 0.5)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              textStyle: TextStyle(color: AppColor.white),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)))));
}
