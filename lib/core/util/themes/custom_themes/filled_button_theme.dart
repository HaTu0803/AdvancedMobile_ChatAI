import 'package:advancedmobile_chatai/core/util/themes/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

import '../colors.dart';

class TFilledButtonTheme {
  TFilledButtonTheme._();

  static final LightFilledButtonTheme = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textLight,
      textStyle: TTextTheme.lightTextTheme.bodyLarge,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      minimumSize: const Size(72, 36),
    ),
  );

  static final DarkFilledButtonTheme = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: AppColors.textDark,
      textStyle: TTextTheme.darkTextTheme.bodyLarge,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      minimumSize: const Size(72, 36),
    ),
  );
}
