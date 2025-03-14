import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onConfirm;
  final bool isConfirmation;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.message,
    this.onConfirm,
    this.isConfirmation = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      content: Text(message, style: const TextStyle(fontSize: 16)),
      actions: [
        if (isConfirmation)
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            if (onConfirm != null) {
              Future.microtask(onConfirm!);
            }
          },
          child: Text(isConfirmation ? "Confirm" : "OK"),
        ),
      ],
    );
  }
}
