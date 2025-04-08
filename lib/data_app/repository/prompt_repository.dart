import 'package:advancedmobile_chatai/data_app/model/jarvis/prompt_model.dart';
import 'package:advancedmobile_chatai/data_app/remote/jarvis/prompt_remote.dart';
import 'package:flutter/foundation.dart';

class PromptRepository {
  final JarvisPromptApiClient promptApiClient = JarvisPromptApiClient();

  Future<PromptResponse> getPrompts() async {
    try {
      return await promptApiClient.getPrompts();
    } catch (e) {
      debugPrint("Error fetching prompts: $e");
      rethrow;
    }
  }

  Future<CreatePromptResponse> createPrompt(CreatePromptRequest request) async {
    try {
      print("Request: ${request.toJson()}");
      return await promptApiClient.createPrompt(request);

    } catch (e) {
      debugPrint("Create Prompt Error: \${e.toString()}");
      rethrow;
    }
  }

  // Future<PromptModel> updatePrompt(String id, UpdatePromptRequest request) async {
  //   try {
  //     return await promptApiClient.updatePrompt(id, request);
  //   } catch (e) {
  //     debugPrint("Update Prompt Error: \${e.toString()}");
  //     rethrow;
  //   }
  // }

  // Future<void> deletePrompt(String id) async {
  //   try {
  //     await promptApiClient.deletePrompt(id);
  //   } catch (e) {
  //     debugPrint("Delete Prompt Error: \${e.toString()}");
  //     rethrow;
  //   }
  // }

  // Future<void> addPromptToFavorites(String id) async {
  //   try {
  //     await promptApiClient.addPromptToFavorites(id);
  //   } catch (e) {
  //     debugPrint("Add to Favorites Error: \${e.toString()}");
  //     rethrow;
  //   }
  // }

  // Future<void> removePromptFromFavorites(String id) async {
  //   try {
  //     await promptApiClient.removePromptFromFavorites(id);
  //   } catch (e) {
  //     debugPrint("Remove from Favorites Error: \${e.toString()}");
  //     rethrow;
  //   }
  // }
}
