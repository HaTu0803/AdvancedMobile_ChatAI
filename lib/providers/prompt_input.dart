import 'package:flutter/material.dart';

class PromptInputProvider extends ChangeNotifier {
  String _content = '';

  String get content => _content;

  void setContent(String value) {
    _content = value;
    notifyListeners();
    print('PromptInputProvider: setContent 123: $_content');
  }

  void clear() {
    _content = '';
    notifyListeners();
  }
}
