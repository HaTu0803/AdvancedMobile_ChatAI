import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onConfirm;
  final bool isConfirmation; // Kiểm tra loại hộp thoại

  const CustomDialog({
    Key? key,
    required this.title,
    required this.message,
    this.onConfirm,
    this.isConfirmation = false, // Mặc định là hộp thoại thông báo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      content: Text(message, style: const TextStyle(fontSize: 16)),
      actions: [
        if (isConfirmation) // Nếu là hộp thoại xác nhận, hiển thị nút "Cancel"
          TextButton(
            onPressed: () => Navigator.pop(context), // Đóng hộp thoại khi bấm "Cancel"
            child: const Text("Cancel"),
          ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Đóng hộp thoại trước
            if (onConfirm != null) {
              Future.microtask(onConfirm!); // Chạy hành động sau khi đóng hộp thoại
            }
          },
          child: Text(isConfirmation ? "Confirm" : "OK"), // Nếu là xác nhận thì hiển thị "Confirm"
        ),
      ],
    );
  }
}
