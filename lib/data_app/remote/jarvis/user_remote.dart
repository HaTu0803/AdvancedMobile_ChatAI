import 'dart:convert';

import 'package:advancedmobile_chatai/core/config/api_headers.dart';
import 'package:advancedmobile_chatai/core/helpers/dialog_helper.dart';
import 'package:advancedmobile_chatai/core/helpers/refresh_token_helper.dart';
import 'package:advancedmobile_chatai/core/local_storage/base_preferences.dart';
import 'package:advancedmobile_chatai/data_app/model/jarvis/user_model.dart';
import 'package:advancedmobile_chatai/data_app/url_api/jarvis/user_url.dart';
import 'package:http/http.dart' as http;

class UserApiClient {
  Future<CurrentUserReponse> getCurrentUser() async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    print("🔑 AccessToken: $token");

    final url = Uri.parse(ApiJarvisUserUrl.getCurrentUser);
    final headers = ApiHeaders.getAIChatHeaders("", token);

    final response = await http.get(url, headers: headers);

    print("📩 response.statusCode: ${response.statusCode}");
    print("📩 response.body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return CurrentUserReponse.fromJson(jsonDecode(response.body)['data']);
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        headers: headers,
        body: null,
      );

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return CurrentUserReponse.fromJson(
            jsonDecode(retryResponse.body)['data']);
      } else {
        DialogHelper.showError(
            'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      DialogHelper.showError('Lỗi: ${response.statusCode}');
      throw Exception('Lỗi: ${response.statusCode}');
    }
  }
}
