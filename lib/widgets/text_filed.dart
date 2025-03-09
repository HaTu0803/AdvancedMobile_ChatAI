import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../util/themes/colors.dart';
import '../util/themes/custom_themes/text_theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final FocusNode focusNode;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? toggleVisibility;
  final String? errorText;
  final Color? backgroundColor; // Add background color parameter

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.focusNode,
    this.isPassword = false,
    this.obscureText = false,
    this.toggleVisibility,
    this.errorText,
    this.backgroundColor, // Include the background color parameter
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? AppColors.textLight : AppColors.textDark;
    final borderColor = errorText != null
        ? AppColors.error
        : (isDarkMode ? AppColors.primaryDarkActive : AppColors.primaryLightActive);

    final inputTextStyle = isDarkMode
        ? TTextTheme.darkTextTheme.bodyLarge
        : TTextTheme.lightTextTheme.bodyLarge;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            style: inputTextStyle?.copyWith(color: textColor),
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText,
            obscuringCharacter: '*',
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: inputTextStyle?.copyWith(color: Colors.grey),
              prefixIcon: Icon(
                icon,
                color: focusNode.hasFocus
                    ? textColor
                    : AppColors.primary, // Only change color when the field is focused
              ),
              suffixIcon: isPassword
                  ? GestureDetector(
                onTap: toggleVisibility,
                child: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: focusNode.hasFocus
                      ? textColor
                      : AppColors.textGray, // Only change color when the password field is focused
                ),
              )
                  : null,
              contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryLightHover,
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor), // Border when focused
                borderRadius: BorderRadius.circular(10.r),
              ),
              errorText: errorText,
              filled: true, // Enable filling the background
              fillColor: backgroundColor ?? (isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight), // Set the background color
            ),
          ),
        ],
      ),
    );
  }
}
