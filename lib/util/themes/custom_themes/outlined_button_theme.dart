import 'package:advancedmobile_chatai/util/themes/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

import '../colors.dart';

class TOutlinedButtonTheme {
  TOutlinedButtonTheme._();

  static final LightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.textDark,
      side: const BorderSide(color: AppColors.primary),
      textStyle: TTextTheme.lightTextTheme.labelLarge,
      padding: const EdgeInsets.symmetric (vertical : 16, horizontal : 20),
      shape: RoundedRectangleBorder (borderRadius: BorderRadius.circular (14)),
    )
  ); // outlinedButtonTheneData

  static final DarkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.textLight,
      side: const BorderSide(color: AppColors.primaryDark),
      textStyle: TTextTheme.darkTextTheme.labelLarge,
      padding: const EdgeInsets.symmetric (vertical : 16, horizontal : 20),
      shape: RoundedRectangleBorder (borderRadius: BorderRadius.circular (14)),
    )
  ); // outlinedButtonTheneData
}