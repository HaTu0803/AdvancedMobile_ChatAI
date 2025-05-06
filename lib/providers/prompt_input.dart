import 'package:flutter/material.dart';

class PromptInputProvider extends ChangeNotifier {
  String _content = '';
  Function(String)? _sendPromptCallback;
  String _language = 'Auto';

  String get content => _content;

  void registerSendPrompt(Function(String) callback) {
    _sendPromptCallback = callback;
  }

  void setInputContent(String value) {
    _content = value;
    notifyListeners();
  }

  void sendPrompt(String content) {
    print('Sending prompt: $content');
    if (_sendPromptCallback != null && content.trim().isNotEmpty) {
      _sendPromptCallback!(content);
      clear(); // hoặc _content = ''; notifyListeners();
    }
  }

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  void clear() {
    _content = '';
    notifyListeners();
  }
}
