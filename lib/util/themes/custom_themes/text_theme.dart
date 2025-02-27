import 'package:flutter/material.dart';
import '../colors.dart';

class TTextTheme {
  TTextTheme._();

  static const TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: AppColors.textDark),
    displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w600, color: AppColors.textDark),
    displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w600, color: AppColors.textDark),

    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textDark),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.textDark),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textDark),

    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textDark),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textDark),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textDark),

    bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.textDark),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textGray),

    labelLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.textDark),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.textGray),
  );

  static const TextTheme darkTextTheme = TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textLight),
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textLight),
    headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textLight),

    titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textLight),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textLight),
    titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textLight),

    bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textLight),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.textLight),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white70),

    labelLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.textLight),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white70),
  );
}
