import 'package:flutter/material.dart';

class PromptInputProvider extends ChangeNotifier {
  String _content = '';

  String get content => _content;

  void setInputContent(String value) {
    _content = value;
    notifyListeners();
    print('PromptInputProvider: setInputContent: $_content');
  }

  void sendPrompt(String value) {
    _content = value;
    notifyListeners();
    print('PromptInputProvider: sendPrompt: $_content');
    _sendToBot(value);
  }

  void _sendToBot(String content) {
    print('Sending to bot: $content');
    // Gửi message thật sự ở đây
  }

  void clear() {
    _content = '';
    notifyListeners();
  }
}
