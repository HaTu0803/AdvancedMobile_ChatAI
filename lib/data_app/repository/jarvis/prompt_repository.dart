import 'package:advancedmobile_chatai/data_app/model/jarvis/prompt_model.dart';
import 'package:advancedmobile_chatai/data_app/remote/jarvis/prompt_remote.dart';
import 'package:flutter/foundation.dart';

class PromptRepository {
  final JarvisPromptApiClient promptApiClient = JarvisPromptApiClient();

  Future<PromptResponse> getPrompts() async {
    try {
      final response = await promptApiClient.getPrompts();
      debugPrint("Fetched prompts: ${response}");
      return response;
    } catch (e) {
      debugPrint("Error fetching prompts: $e");
      rethrow;
    }
  }

  Future<CreatePromptResponse> createPrompt(CreatePromptRequest request) async {
    try {
      final response = await promptApiClient.createPrompt(request);
      debugPrint("Create Prompt Response: ${response}");
      return response;
    } catch (e) {
      debugPrint("Create Prompt Error: \${e.toString()}");
      rethrow;
    }
  }

  Future<GetPromptResponse> getPrompt(GetPromptRequest? params) async {
    try {
      final response = await promptApiClient.getPrompt(params);
      debugPrint("Get Prompt Response: ${response}");
      return response;
    } catch (e) {
      debugPrint("Get Prompt Error: \${e.toString()}");
      rethrow;
    }
  }

  Future<CreatePromptResponse> updatePrompt(
      String id, CreatePromptRequest request) async {
    try {
      return await promptApiClient.updatePrompt(id, request);
    } catch (e) {
      debugPrint("Update Prompt Error: \${e.toString()}");
      rethrow;
    }
  }

  Future<DeletePromptResponse> deletePrompt(String id) async {
    try {
      final response = promptApiClient.deletePrompt(id);
      debugPrint("Delete Prompt Response: ${response}");
      return response;
    } catch (e) {
      debugPrint("Delete Prompt Error: \${e.toString()}");
      rethrow;
    }
  }

  Future<void> addPromptToFavorites(String id) async {
    try {
      await promptApiClient.addPromptToFavorites(id);
    } catch (e) {
      debugPrint("Add to Favorites Error: ${e.toString()}");
      rethrow;
    }
  }

  Future<void> removePromptFromFavorites(String id) async {
    try {
      await promptApiClient.removePromptFromFavorites(id);
    } catch (e) {
      debugPrint("Remove from Favorites Error: ${e.toString()}");
      rethrow;
    }
  }
}
