import 'dart:convert';

import 'package:advancedmobile_chatai/core/config/api_headers.dart';
import 'package:advancedmobile_chatai/core/local_storage/base_preferences.dart';
import 'package:advancedmobile_chatai/core/util/exception.dart';
import 'package:advancedmobile_chatai/data_app/model/jarvis/prompt_model.dart';
import 'package:advancedmobile_chatai/data_app/remote/auth/auth_api_client.dart';
import 'package:advancedmobile_chatai/data_app/url_api/jarvis/prompt_url.dart';
import 'package:http/http.dart' as http;

import '../../repository/authentication_repository.dart';

class JarvisPromptApiClient {
  Future<PromptResponse> getPrompts() async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');

    final response = await http.get(
      Uri.parse(ApiJarvisPromptUrl.getPrompts),
      headers: ApiHeaders.getAIChatHeaders("", token),
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

  Future<CreatePromptResponse> createPrompt(CreatePromptRequest request) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    print("🔑 AccessToken: $token");

    final response = await http.post(
      Uri.parse(ApiJarvisPromptUrl.createPrompt),
      headers: ApiHeaders.getAIChatHeaders("", token),
      body: jsonEncode(request.toJson()),
    );

    print("📩 response.statusCode: ${response.statusCode}");
    print("📩 response.body: ${response.body}");

    if (response.statusCode == 201 || response.statusCode == 200) {
      return CreatePromptResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      print("🔄 Token expired. Refreshing...");
      final newToken = await AuthRepository().fetchRefreshToken();
      if (newToken != null) {
        // Gọi lại request sau khi refresh
        final retryResponse = await http.post(
          Uri.parse(ApiJarvisPromptUrl.createPrompt),
          headers: ApiHeaders.getAIChatHeaders("", newToken),
          body: jsonEncode(request.toJson()),
        );

        if (retryResponse.statusCode == 201 ||
            retryResponse.statusCode == 200) {
          return CreatePromptResponse.fromJson(jsonDecode(retryResponse.body));
        } else {
          throw Exception('❌ Retry failed: ${retryResponse.statusCode}');
        }
      } else {
        throw UnauthorizedException("Token expired and refresh failed");
      }
    } else {
      throw Exception('❌ Failed to create prompt: ${response.statusCode}');
    }
  }

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
