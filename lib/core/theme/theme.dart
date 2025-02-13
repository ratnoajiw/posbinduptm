import 'package:flutter/material.dart';
import 'package:posbinduptm/core/theme/app_pallete.dart';

class AppTheme {
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      );

  // Light Theme Mode
  static final lightThemeMode = ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black, // Warna teks ikon
    ),
    chipTheme: const ChipThemeData(
      color: WidgetStatePropertyAll(
        Colors.white,
      ),
      side: BorderSide.none,
    ),
    scaffoldBackgroundColor: Colors.white,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      border: _border(Colors.grey),
      enabledBorder: _border(Colors.grey),
      focusedBorder: _border(AppPallete.gradientGreen2),
      errorBorder: _border(AppPallete.errorColor),
    ),
  );

  // Dark Theme Mode
  static final darkThemeMode = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.backgroundColor,
    ),
    chipTheme: const ChipThemeData(
      color: WidgetStatePropertyAll(
        AppPallete.backgroundColor,
      ),
      side: BorderSide.none,
    ),
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.gradientGreen2),
      errorBorder: _border(AppPallete.errorColor),
    ),
  );
}
