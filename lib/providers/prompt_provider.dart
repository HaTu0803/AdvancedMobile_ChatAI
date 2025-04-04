import 'package:advancedmobile_chatai/data_app/model/jarvis/prompt_model.dart';
import 'package:advancedmobile_chatai/data_app/repository/prompt_repository.dart';
import 'package:flutter/material.dart';

class PromptProvider with ChangeNotifier {
  final PromptRepository promptRepository = PromptRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  PromptResponse? _prompts;
  PromptResponse? get prompts => _prompts;

  Future<dynamic> fetchPrompts() async {
    setLoading(true);
    try {
      _prompts = await promptRepository.getPrompts();
      print(_prompts);
      notifyListeners();
      return _prompts;
    } catch (e) {
      print(e);
      debugPrint("Error fetching prompts: $e");
      return null;
    } finally {
      setLoading(false);
    }
  }
}
