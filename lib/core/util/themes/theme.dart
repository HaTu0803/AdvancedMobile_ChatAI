import 'package:flutter/material.dart';

import 'colors.dart';
import 'custom_themes/elevated_button_theme.dart';
import 'custom_themes/filled_button_theme.dart';
import 'custom_themes/outlined_button_theme.dart';
import 'custom_themes/text_field_theme.dart';
import 'custom_themes/text_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    textTheme: TTextTheme.lightTextTheme,
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll<Color>(AppColors.iconColorDark),
        
      ),
    ),
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.LightOutlinedButtonTheme,
    filledButtonTheme: TFilledButtonTheme.LightFilledButtonTheme,
    dividerColor: AppColors.divider,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.textLight,
      primaryContainer: AppColors.primaryLight,
      secondary: AppColors.secondary,
      onSecondary: AppColors.textDark,
      secondaryContainer: AppColors.secondaryLight,
      surface: AppColors.backgroundLight,
      onSurface: AppColors.textDark,
      error: AppColors.error,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: TTextTheme.darkTextTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.DarkOutlinedButtonTheme,
    filledButtonTheme: TFilledButtonTheme.DarkFilledButtonTheme,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark,
      onPrimary: AppColors.textLight,
      primaryContainer: AppColors.primary,
      secondary: AppColors.secondaryDark,
      onSecondary: AppColors.textLight,
      secondaryContainer: AppColors.secondaryDarkHover,
      surface: AppColors.backgroundDark,
      onSurface: AppColors.textLight,
      error: AppColors.error,
    ),
  );
}
