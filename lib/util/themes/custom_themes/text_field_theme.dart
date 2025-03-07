import 'package:advancedmobile_chatai/util/themes/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';
import '../colors.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: AppColors.textGray,
    suffixIconColor: AppColors.textGray,

    labelStyle: TTextTheme.lightTextTheme.bodyMedium,
    hintStyle: TTextTheme.lightTextTheme.bodySmall,
    errorStyle: TTextTheme.lightTextTheme.labelMedium?.copyWith(color: AppColors.error),
    floatingLabelStyle: TTextTheme.lightTextTheme.bodyMedium?.copyWith(color: AppColors.textDark.withOpacity(0.8)),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 1, color: AppColors.textGrayDarker),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 1, color: AppColors.textGrayDarker),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 1.5, color: AppColors.primary),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 1, color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 1.5, color: AppColors.warning),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: AppColors.textGray,
    suffixIconColor: AppColors.textGray,

    labelStyle: TTextTheme.darkTextTheme.bodyMedium,
    hintStyle: TTextTheme.darkTextTheme.bodySmall,
    errorStyle: TTextTheme.darkTextTheme.labelMedium?.copyWith(color: AppColors.error),
    floatingLabelStyle: TTextTheme.darkTextTheme.bodyMedium?.copyWith(color: AppColors.textLight.withOpacity(0.8)),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 1, color: AppColors.textGray),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 1, color: AppColors.textGray),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 1.5, color: AppColors.primaryLight),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 1, color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 1.5, color: AppColors.warning),
    ),
  );
}
