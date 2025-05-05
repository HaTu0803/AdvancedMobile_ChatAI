import 'dart:convert';

import 'package:advancedmobile_chatai/core/config/api_headers.dart';
import 'package:advancedmobile_chatai/core/helpers/dialog_helper.dart';
import 'package:advancedmobile_chatai/core/helpers/refresh_token_helper.dart';
import 'package:advancedmobile_chatai/core/local_storage/base_preferences.dart';
import 'package:advancedmobile_chatai/core/navigation/routes.dart';
import 'package:advancedmobile_chatai/data_app/model/jarvis/prompt_model.dart';
import 'package:advancedmobile_chatai/data_app/url_api/jarvis/prompt_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../repository/auth/authentication_repository.dart';

class JarvisPromptApiClient {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<PromptResponse> getPrompts() async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    final url = Uri.parse(ApiJarvisPromptUrl.getPrompts);
    final headers = ApiHeaders.getAIChatHeaders("", token);
    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      print(response.body);
      return PromptResponse.fromJson(jsonResponse);
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        method: 'GET',
      );

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return PromptResponse.fromJson(jsonDecode(retryResponse.body));
      } else {
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      handleErrorResponse(response);

      throw Exception('Failed to fetch prompts');
    }
  }

  Future<GetPromptResponse> getPrompt(GetPromptRequest params) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    final uri = Uri.parse(ApiJarvisPromptUrl.getPrompts)
        .replace(queryParameters: params.toQueryParams());

    final response = await http.get(
      uri,
      headers: ApiHeaders.getAIChatHeaders("", token),
    );
    print("📩 response.statusCode: ${response.statusCode}");
    print("📩 response.body params: ${response.body}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return GetPromptResponse.fromJson(jsonResponse);
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: uri,
        method: 'GET',
      );

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return GetPromptResponse.fromJson(jsonDecode(retryResponse.body));
      } else {
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      handleErrorResponse(response);
      throw Exception('Failed to fetch prompts by category');
    }
  }

  Future<CreatePromptResponse> createPrompt(CreatePromptRequest request) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    final uri = Uri.parse(ApiJarvisPromptUrl.createPrompt);
    final headers = ApiHeaders.getAIChatHeaders("", token);
    final body = jsonEncode(request.toJson());
    final response = await http.post(
      uri,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return CreatePromptResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: uri,
        body: body,
        method: 'POST',
      );

      if (retryResponse.statusCode == 201 || retryResponse.statusCode == 200) {
        return CreatePromptResponse.fromJson(jsonDecode(retryResponse.body));
      } else {
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      handleErrorResponse(response);
      throw Exception('❌ Failed to create prompt: ${response.statusCode}');
    }
  }

  Future<CreatePromptResponse> updatePrompt(
      String id, CreatePromptRequest request) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    final uri = Uri.parse(ApiJarvisPromptUrl.updatePrompt(id));
    final headers = ApiHeaders.getAIChatHeaders("", token);
    final body = jsonEncode(request.toJson());
    final response = await http.patch(
      uri,
      headers: headers,
      body: body,
    );
    print("📩 response.statusCode: ${response.statusCode}");
    print("📩 response.body update: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return CreatePromptResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: uri,
        body: body,
        method: 'PATCH',
      );

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return CreatePromptResponse.fromJson(jsonDecode(retryResponse.body));
      } else {
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      handleErrorResponse(response);
      throw Exception('❌ Failed to update prompt: ${response.statusCode}');
    }
  }

  Future<DeletePromptResponse> deletePrompt(String id) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    final uri = Uri.parse(ApiJarvisPromptUrl.deletePrompt(id));
    final headers = ApiHeaders.getAIChatHeaders("", token);
    final response = await http.delete(
      uri,
      headers: headers,
    );
    print("📩 response.statusCode: ${response.statusCode}");
    print("📩 response.body: ${response.body}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      return DeletePromptResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: uri,
        method: 'DELETE',
      );

      if (retryResponse.statusCode == 201 || retryResponse.statusCode == 200) {
        return DeletePromptResponse.fromJson(jsonDecode(retryResponse.body));
      } else {
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      handleErrorResponse(response);
      throw Exception('❌ Failed to delete prompt: ${response.statusCode}');
    }
  }

  Future<void> addPromptToFavorites(String id) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');

    final response = await http.post(
      Uri.parse(ApiJarvisPromptUrl.addPromptToFavorites(id)),
      headers: ApiHeaders.getAIChatHeaders("", token),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add prompt to favorites');
    }
  }

  Future<void> removePromptFromFavorites(String id) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');

    final response = await http.delete(
      Uri.parse(ApiJarvisPromptUrl.removePromptFromFavorites(id)),
      headers: ApiHeaders.getAIChatHeaders("", token),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to remove prompt from favorites');
    }
  }
}
