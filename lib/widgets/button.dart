import 'package:flutter/material.dart';
import 'package:advancedmobile_chatai/util/themes/custom_themes/text_theme.dart';
import '../util/themes/colors.dart';

enum ButtonType { filled, outlined, textOnly, iconOnly }

class TCustomButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onPressed;
  final ButtonType type;
  final ButtonStyle? customStyle; // A single parameter for all customizations

  const TCustomButton({
    super.key,
    this.text,
    this.icon,
    required this.onPressed,
    this.type = ButtonType.filled,
    this.customStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final defaultBackgroundColor = customStyle?.backgroundColor?.resolve({}) ??
        (isDarkMode ? AppColors.primaryDark : AppColors.primary);
    final defaultTextColor = customStyle?.foregroundColor?.resolve({}) ??
        (isDarkMode ? AppColors.textLight : AppColors.textDark);
    final defaultBorderColor = customStyle?.side?.resolve({})?.color ??
        (isDarkMode ? AppColors.primaryDark : AppColors.primary);
    final textStyle = isDarkMode
        ? TTextTheme.lightTextTheme.titleLarge
        : TTextTheme.darkTextTheme.titleLarge;

    return ElevatedButton(
      onPressed: onPressed,
      style: customStyle ?? ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          type == ButtonType.outlined || type == ButtonType.textOnly
              ? Colors.transparent
              : defaultBackgroundColor,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: type == ButtonType.outlined
                ? BorderSide(color: defaultBorderColor, width: 2)
                : BorderSide.none,
          ),
        ),
        elevation: WidgetStateProperty.all(type == ButtonType.textOnly ? 0 : 2),
        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16, horizontal: 20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(icon, size: 24, color: defaultTextColor),
          if (icon != null && text != null) const SizedBox(width: 8),
          if (text != null)
            Text(
              text!,
              style: textStyle,
            ),
        ],
      ),
    );
  }
}
