import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF2563EB);
  static const primaryDark = Color(0xFF1D4ED8);
  static const secondary = Color(0xFFEFF6FF);
  static const tertiary = Color(0xFF1E3A8A);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      expansionTileTheme: const ExpansionTileThemeData(
        expandedAlignment: Alignment.centerLeft,
        shape: RoundedRectangleBorder(side: BorderSide.none),
        collapsedShape: RoundedRectangleBorder(side: BorderSide.none),
      ));
}
