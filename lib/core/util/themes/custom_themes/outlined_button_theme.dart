import 'package:advancedmobile_chatai/core/util/themes/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

import '../colors.dart';

class TOutlinedButtonTheme {
  TOutlinedButtonTheme._();

  static final LightOutlinedButtonTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
    elevation: 0,
    foregroundColor: AppColors.textDark,
    side: const BorderSide(color: AppColors.primary),
    textStyle: TTextTheme.lightTextTheme.titleMedium,
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(72, 36),
      )); // outlinedButtonTheneData

  static final DarkOutlinedButtonTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
    elevation: 0,
    foregroundColor: AppColors.textLight,
    side: const BorderSide(color: AppColors.primaryDark),
    textStyle: TTextTheme.darkTextTheme.titleMedium,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(72, 36),

      )); // outlinedButtonTheneData
}
