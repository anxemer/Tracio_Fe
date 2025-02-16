import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static final appTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.dark,
    fontFamily: 'CircularStd',
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.background,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(
          color: Color(0xffA7A7A7),
          fontWeight: FontWeight.w400,
        ),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            elevation: 0,
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)))),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.background,
      selectionColor: AppColors.background,
      selectionHandleColor: AppColors.background,
    ),
  );
}
