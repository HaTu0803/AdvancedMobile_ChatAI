import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class DialogHelper {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void showSuccess(String message) {
    if (navigatorKey.currentContext != null) {
      AwesomeDialog(
        context: navigatorKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Thành công',
        desc: message,
        btnOkOnPress: () {},
        btnOkText: 'Đóng',
      ).show();
    }
  }

  static void showError(String message) {
    if (navigatorKey.currentContext != null) {
      AwesomeDialog(
        context: navigatorKey.currentContext!,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: 'Lỗi',
        desc: message,
        btnOkOnPress: () {},
        btnOkText: 'Đóng',
      ).show();
    }
  }
}