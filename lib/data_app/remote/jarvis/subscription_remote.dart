import 'dart:convert';

import 'package:advancedmobile_chatai/core/config/api_headers.dart';
import 'package:advancedmobile_chatai/core/helpers/dialog_helper.dart';
import 'package:advancedmobile_chatai/core/helpers/refresh_token_helper.dart';
import 'package:advancedmobile_chatai/core/local_storage/base_preferences.dart';
import 'package:advancedmobile_chatai/data_app/model/jarvis/subscription_model.dart';
import 'package:advancedmobile_chatai/data_app/url_api/jarvis/subcription_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/navigation/routes.dart';
import '../../repository/auth/authentication_repository.dart';

class SubscriptionApiClient {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<UsageResponse> getUsage() async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');
      print("AccessToken: $token");

      if (token.isEmpty) {
        throw Exception("No access token found");
      }

      final url = Uri.parse(ApiJarvisSubscriptionUrl.getUsage);

      final headers = ApiHeaders.getAIChatHeaders("", token);

      final response = await http.get(url, headers: headers);

      print("📩 response.statusCode: ${response.statusCode}");
      print("📩 response.body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return UsageResponse.fromJson(responseData);
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
          headers: headers,
          body: null,
          method: 'GET',
        );

        if (retryResponse.statusCode == 200 ||
            retryResponse.statusCode == 201) {
          final responseData = jsonDecode(retryResponse.body);
          return UsageResponse.fromJson(responseData);
        } else {
          await AuthRepository().logOut();
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            AppRoutes.login,
            (route) => true,
          );
          throw Exception('Session expired. Please log in again.');
        }
      } else {
        final errorMessage = _parseErrorMessage(response.body);
        throw Exception('Error ${response.statusCode}: $errorMessage');
      }
    } catch (e, stackTrace) {
      debugPrint("❌ SubscriptionApiClient Error: $e");
      debugPrint("📍 SubscriptionApiClient Stack trace: $stackTrace");
      rethrow;
    }
  }

  Future<bool> subscribe() async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    print("🔑 AccessToken: $token");

    final url = Uri.parse(ApiJarvisSubscriptionUrl.subscribe);
    final headers = ApiHeaders.getAIChatHeaders("", token);

    final response = await http.get(url, headers: headers);

    print("📩 response.statusCode: ${response.statusCode}");
    print("📩 response.body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        headers: headers,
        body: null,
        method: 'GET',
      );

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return true;
      } else {
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      DialogHelper.showError('Lỗi: ${response.statusCode}');
      throw Exception('Lỗi: ${response.statusCode}');
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
