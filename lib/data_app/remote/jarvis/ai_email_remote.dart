import 'dart:convert';

import 'package:advancedmobile_chatai/core/config/api_headers.dart';
import 'package:advancedmobile_chatai/core/helpers/dialog_helper.dart';
import 'package:advancedmobile_chatai/core/helpers/refresh_token_helper.dart';
import 'package:advancedmobile_chatai/core/local_storage/base_preferences.dart';
import 'package:advancedmobile_chatai/data_app/model/jarvis/ai_email_model.dart';
import 'package:advancedmobile_chatai/data_app/url_api/jarvis/ai_email_url.dart';
import 'package:http/http.dart' as http;

class AiEmailApiClient {
  Future<EmailResponse> responseEmail(EmailResponseModel request) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    print("🔑 AccessToken: $token");

    final url = Uri.parse(ApiJarvisAiEmailUrl.responseEmail);
    final headers = ApiHeaders.getAIChatHeaders("", token);
    final body = jsonEncode(request.toJson());

    final response = await http.post(url, headers: headers, body: body);

    print("📩 response.statusCode: ${response.statusCode}");
    print("📩 response.body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return EmailResponse.fromJson(jsonDecode(response.body)['data']);
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        headers: headers,
        body: body,
      );

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return EmailResponse.fromJson(jsonDecode(retryResponse.body)['data']);
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

  Future<IdeaResponse> suggestReplyIdeas(SuggestReplyIdeas request) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    print("🔑 AccessToken: $token");

    final url = Uri.parse(ApiJarvisAiEmailUrl.suggestReplyIdeas);
    final headers = ApiHeaders.getAIChatHeaders("", token);
    final body = jsonEncode(request.toJson());

    final response = await http.post(url, headers: headers, body: body);

    print("📩 response.statusCode: ${response.statusCode}");
    print("📩 response.body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return IdeaResponse.fromJson(jsonDecode(response.body)['data']);
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        headers: headers,
        body: body,
      );

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return IdeaResponse.fromJson(jsonDecode(retryResponse.body)['data']);
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
