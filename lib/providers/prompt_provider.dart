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

  List<PromptCategory> _categories = [];
  List<PromptCategory> get categories => _categories;

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

  Future<void> fetchCategories() async {
    setLoading(true);
    try {
      // Ensure we have prompts data
      if (_prompts == null) {
        await fetchPrompts();
      }

      // Extract unique categories from prompts
      final Set<String> uniqueCategories = {};
      _prompts?.items.forEach((prompt) {
        if (prompt.category != null && prompt.category!.isNotEmpty) {
          uniqueCategories.add(prompt.category!);
        }
      });

      // Convert to list of PromptCategory
      _categories = uniqueCategories
          .map((category) => PromptCategory(
                name: category,
                isSelected: false,
                id: category.toLowerCase().replaceAll(' ', '-'),
              ))
          .toList();

      // Sort categories alphabetically
      _categories.sort((a, b) => a.name.compareTo(b.name));

      // Add 'All' category at the beginning
      _categories.insert(0, PromptCategory(name: 'All', isSelected: true, id: 'all'));
      
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    } finally {
      setLoading(false);
    }
  }
}
