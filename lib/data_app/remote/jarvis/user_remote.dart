import 'dart:convert';

import 'package:advancedmobile_chatai/core/config/api_headers.dart';
import 'package:advancedmobile_chatai/core/helpers/dialog_helper.dart';
import 'package:advancedmobile_chatai/core/helpers/refresh_token_helper.dart';
import 'package:advancedmobile_chatai/core/local_storage/base_preferences.dart';
import 'package:advancedmobile_chatai/data_app/model/jarvis/user_model.dart';
import 'package:advancedmobile_chatai/data_app/url_api/jarvis/user_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/navigation/routes.dart';
import '../../repository/auth/authentication_repository.dart';

class UserApiClient {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<CurrentUserReponse> getCurrentUser() async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');
      debugPrint("🔑 UserApiClient - Access Token: $token");

      if (token.isEmpty) {
        throw Exception("No access token found");
      }

      final url = Uri.parse(ApiJarvisUserUrl.getCurrentUser);
      debugPrint("🌐 UserApiClient - Request URL: ${url.toString()}");
      
      final headers = ApiHeaders.getAIChatHeaders("", token);
      debugPrint("📤 UserApiClient - Request Headers: $headers");

      final response = await http.get(url, headers: headers);

      debugPrint("📥 UserApiClient - Response Status Code: ${response.statusCode}");
      debugPrint("📥 UserApiClient - Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return CurrentUserReponse.fromJson(responseData);
      } else if (response.statusCode == 401) {
        debugPrint("🔄 UserApiClient - Token expired, attempting refresh...");
        final retryResponse = await retryWithRefreshToken(
          url: url,
          headers: headers,
          body: null,
        );

        debugPrint("📥 UserApiClient - Retry Response Status Code: ${retryResponse.statusCode}");
        debugPrint("📥 UserApiClient - Retry Response Body: ${retryResponse.body}");

        if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
          final responseData = jsonDecode(retryResponse.body);
          return CurrentUserReponse.fromJson(responseData);
        } else {
          debugPrint("❌ UserApiClient - Retry failed, logging out...");
          await AuthRepository().logOut();
          throw Exception('Session expired. Please log in again.');
        }
      } else {
        final errorMessage = _parseErrorMessage(response.body);
        throw Exception('Error ${response.statusCode}: $errorMessage');
      }
    } catch (e, stackTrace) {
      debugPrint("❌ UserApiClient Error: $e");
      debugPrint("📍 UserApiClient Stack trace: $stackTrace");
      rethrow;
    }
  }

  String _parseErrorMessage(String responseBody) {
    try {
      final bodyMap = jsonDecode(responseBody);
      return bodyMap['message'] ?? bodyMap['error'] ?? 'Unknown error';
    } catch (e) {
      return responseBody;
    }
  }
}
