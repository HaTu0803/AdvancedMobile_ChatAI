import 'package:flutter/material.dart';

import '../core/util/themes/colors.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Object message;
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
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: message is String
          ? Text(
        message as String,
        style: Theme.of(context).textTheme.titleLarge,
      )
          : message as Widget,
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        if (isConfirmation)
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textGrayDarker,
            ),
            child: Text(
              cancelText,
              style: const TextStyle(fontSize: 12), 
            ),
          ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm?.call();
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: Text(isConfirmation ? confirmText : "OK" ,
              style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}


void showCustomDialog({
  required BuildContext context,
  required String title,
  required Object message,
  VoidCallback? onConfirm,
  bool isConfirmation = false,
  String confirmText = "Confirm",
  String cancelText = "Cancel",
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
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
