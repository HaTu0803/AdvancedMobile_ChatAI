import 'package:advancedmobile_chatai/util/themes/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

import '../colors.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  static ElevatedButtonThemeData lightElevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.textLight,
      backgroundColor: AppColors.primary,
      disabledForegroundColor: AppColors.textGrayDarker,
      disabledBackgroundColor: AppColors.unSelected,
      side: const BorderSide(color: AppColors.primary),
      padding: const EdgeInsets.symmetric(vertical: 18),
      textStyle: TTextTheme.lightTextTheme.labelLarge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static ElevatedButtonThemeData darkElevatedButtonTheme =
      ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.textLight,
      backgroundColor: AppColors.primaryDark,
      disabledForegroundColor: AppColors.textGrayDarker,
      disabledBackgroundColor: AppColors.unSelected,
      side: const BorderSide(color: AppColors.primaryDark),
      padding: const EdgeInsets.symmetric(vertical: 18),
      textStyle: TTextTheme.darkTextTheme.labelLarge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
