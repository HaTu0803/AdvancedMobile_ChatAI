import 'dart:convert';

import 'package:advancedmobile_chatai/core/config/api_headers.dart';
import 'package:advancedmobile_chatai/core/local_storage/base_preferences.dart';
import 'package:advancedmobile_chatai/data_app/model/jarvis/prompt_model.dart';
import 'package:advancedmobile_chatai/data_app/url_api/jarvis/prompt_url.dart';
import 'package:http/http.dart' as http;

class JarvisPromptApiClient {
  Future<PromptResponse> getPrompts() async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');

    final headers = {
      ...ApiHeaders.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse(ApiJarvisPromptUrl.getPrompts),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      print(response.body);
      return PromptResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to fetch prompts');
    }
  }


  // Future<PromptModel> createPrompt(CreatePromptRequest request) async {
  //   final response = await http.post(
  //     Uri.parse(ApiJarvisPromptUrl.createPrompt),
  //     headers: ApiHeaders.defaultHeaders,
  //     body: jsonEncode(request.toJson()),
  //   );
  //   if (response.statusCode == 201) {
  //     return PromptModel.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to create prompt');
  //   }
  // }

  // Future<PromptModel> updatePrompt(String id, UpdatePromptRequest request) async {
  //   final response = await http.put(
  //     Uri.parse(ApiJarvisPromptUrl.updatePrompt(id)),
  //     headers: ApiHeaders.defaultHeaders,
  //     body: jsonEncode(request.toJson()),
  //   );
  //   if (response.statusCode == 200) {
  //     return PromptModel.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to update prompt');
  //   }
  // }

  // Future<void> deletePrompt(String id) async {
  //   final response = await http.delete(
  //     Uri.parse(ApiJarvisPromptUrl.deletePrompt(id)),
  //     headers: ApiHeaders.defaultHeaders,
  //   );
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to delete prompt');
  //   }
  // }

  // Future<void> addPromptToFavorites(String id) async {
  //   final response = await http.post(
  //     Uri.parse(ApiJarvisPromptUrl.addPromptToFavorites(id)),
  //     headers: ApiHeaders.defaultHeaders,
  //   );
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to add prompt to favorites');
  //   }
  // }

  // Future<void> removePromptFromFavorites(String id) async {
  //   final response = await http.delete(
  //     Uri.parse(ApiJarvisPromptUrl.removePromptFromFavorites(id)),
  //     headers: ApiHeaders.defaultHeaders,
  //   );
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to remove prompt from favorites');
  //   }
  // }
}
