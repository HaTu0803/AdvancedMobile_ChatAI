import 'package:advancedmobile_chatai/data_app/model/jarvis/prompt_model.dart';
import 'package:advancedmobile_chatai/data_app/repository/jarvis/prompt_repository.dart';
import 'package:flutter/material.dart';

class PromptProvider with ChangeNotifier {
  final PromptRepository promptRepository = PromptRepository();

  List<PromptItemV2>? _prompts;
  List<PromptCategory> _categories = [];
  bool _isLoading = false;
  GetPromptResponse? _promptResponse;

  List<PromptItemV2>? get prompts => _prompts;
  List<PromptCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  GetPromptResponse? get promptResponse => _promptResponse;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<GetPromptResponse?> fetchPrompts({
    int offset = 0,
    int limit = 10,
    String? category,
    bool? isFavorite,
    String? query,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final params = GetPromptRequest(
        query: query,
        offset: offset,
        limit: limit,
        category: category,
        isFavorite: isFavorite,
        isPublic: true,
      );

      final response = await PromptRepository().getPrompt(params);
      _promptResponse = response;
      
      if (offset == 0) {
        _prompts = response.items;
      } else {
        _prompts = [...?_prompts, ...response.items];
      }

      notifyListeners();
      return response;
    } catch (e) {
      print('Error fetching prompts: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
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
      _prompts?.forEach((prompt) {
        if (prompt.category.isNotEmpty) {
          uniqueCategories.add(prompt.category);
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
      _categories.insert(
          0, PromptCategory(name: 'All', isSelected: true, id: 'all'));

      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    } finally {
      setLoading(false);
    }
  }
}
