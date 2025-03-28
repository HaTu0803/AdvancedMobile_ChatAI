import 'package:flutter/material.dart';

import '../core/util/themes/colors.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onConfirm;
  final bool isConfirmation;
  final String confirmText;
  final String cancelText;

  const CustomDialog({
    super.key,
    required this.title,
    required this.message,
    this.onConfirm,
    this.isConfirmation = false,
    this.confirmText = "Confirm",
    this.cancelText = "Cancel",
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
      actionsAlignment: MainAxisAlignment.end, // Căn nút về góc phải
      actions: [
        if (isConfirmation)
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textGrayDarker,
            ),
            child: Text(cancelText),
          ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm?.call();
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: Text(isConfirmation ? confirmText : "OK"),
        ),
      ],
    );
  }
}

/// Hàm tiện ích để hiển thị hộp thoại
void showCustomDialog({
  required BuildContext context,
  required String title,
  required String message,
  VoidCallback? onConfirm,
  bool isConfirmation = false,
  String confirmText = "Confirm",
  String cancelText = "Cancel",
}) {
  showDialog(
    context: context,
    barrierDismissible: false, // Ngăn người dùng bấm ra ngoài để đóng dialog
    builder: (context) => CustomDialog(
      title: title,
      message: message,
      onConfirm: onConfirm,
      isConfirmation: isConfirmation,
      confirmText: confirmText,
      cancelText: cancelText,
    ),
  );
}
