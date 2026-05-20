import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFFE53935);
  static const primaryDark = Color(0xFFB71C1C);
  static const accent = Color(0xFFFF6F00);
  static const background = Color(0xFFF5F5F5);
  static const cardBg = Colors.white;
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
  static const priceColor = Color(0xFFE53935);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          backgroundColor: Colors.white,
          elevation: 10,
        ),
      );
}
