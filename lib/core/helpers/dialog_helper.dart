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
