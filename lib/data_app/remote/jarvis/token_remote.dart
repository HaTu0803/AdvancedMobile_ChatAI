import 'dart:convert';

import 'package:advancedmobile_chatai/core/config/api_headers.dart';
import 'package:advancedmobile_chatai/core/helpers/dialog_helper.dart';
import 'package:advancedmobile_chatai/core/helpers/refresh_token_helper.dart';
import 'package:advancedmobile_chatai/core/local_storage/base_preferences.dart';
import 'package:advancedmobile_chatai/data_app/model/jarvis/token_model.dart';
import 'package:advancedmobile_chatai/data_app/url_api/jarvis/token_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../core/navigation/routes.dart';
import '../../repository/auth/authentication_repository.dart';

class TokenApiClient {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<UsageTokenResponse> getUsage() async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    print("🔑 AccessToken: $token");

    final url = Uri.parse(ApiJarvisTokenUrl.getUsage);
    final headers = ApiHeaders.getAIChatHeaders("", token);

    final response = await http.get(url, headers: headers);

    print("📩 response.statusCode: ${response.statusCode}");
    print("📩 response.body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return UsageTokenResponse.fromJson(jsonDecode(response.body)['data']);
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        body: null,
      );

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return UsageTokenResponse.fromJson(
            jsonDecode(retryResponse.body)['data']);
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
}
