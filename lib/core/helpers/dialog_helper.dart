import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void showError(String message) {
    _showDialog(
      dialogType: DialogType.error,
      title: 'Lỗi',
      message: message,
    );
  }

  static void _showDialog({
    required DialogType dialogType,
    required String title,
    required String message,
  }) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          AwesomeDialog(
            context: context,
            dialogType: dialogType,
            animType: AnimType.bottomSlide,
            title: title,
            desc: message,
            btnOkOnPress: () {},
            btnOkText: 'Đóng',
          ).show();
        }
      });
    } else {
      debugPrint('⚠️ Không thể hiển thị dialog vì context = null');
    }
  }
}

void handleErrorResponse(response) {
  try {
    final errorData = jsonDecode(response.body);

    final errorMessage = errorData['message'] ?? 'Đã xảy ra lỗi không xác định';
    final errorDetails = errorData['details'];
    String finalMessage = errorMessage;

    if (errorDetails is List && errorDetails.isNotEmpty) {
      // Lấy tất cả các 'issue' nếu có
      final issues = errorDetails
          .where((detail) => detail is Map && detail['issue'] != null)
          .map((detail) => detail['issue'].toString())
          .toList();

      if (issues.isNotEmpty) {
        finalMessage = '$errorMessage:\n- ${issues.join('\n- ')}';
      }
    }

    DialogHelper.showError(finalMessage);
    throw Exception('Lỗi: $finalMessage');
  } catch (e) {
    DialogHelper.showError('Đã xảy ra lỗi: $e');
    throw Exception('Đã xảy ra lỗi: $e');
  }
}
