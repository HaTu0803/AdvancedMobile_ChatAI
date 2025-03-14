import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Icon icon;  // Trực tiếp nhận Icon widget
  final String? label;  // Optional, có thể có hoặc không có text
  final VoidCallback onTap;
  final Color? backgroundColor;  // Màu nền button

  const ActionButton({
    super.key,
    required this.icon,  // Truyền vào Icon widget
    this.label,  // Nếu có label, nó sẽ hiển thị
    required this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final buttonColor = backgroundColor ?? Colors.transparent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: buttonColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon, // Hiển thị trực tiếp icon
            // Nếu có label, hiển thị text sau icon
            if (label != null && label!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  label!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
