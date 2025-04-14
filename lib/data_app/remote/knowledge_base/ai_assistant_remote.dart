import 'dart:convert';

import 'package:advancedmobile_chatai/core/config/api_headers.dart';
import 'package:advancedmobile_chatai/core/helpers/dialog_helper.dart';
import 'package:advancedmobile_chatai/core/helpers/refresh_token_helper.dart';
import 'package:advancedmobile_chatai/core/local_storage/base_preferences.dart';
import 'package:advancedmobile_chatai/data_app/model/knowledge_base/assistant_model.dart';
import 'package:advancedmobile_chatai/data_app/url_api/knowledge_base/ai_assistant_url.dart';
import 'package:http/http.dart' as http;

class AssistantApiClient {
  Future<AssistantResponse?> createAssistant(Assistant request) async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');
      print("🔑 AccessToken: $token");

      final url = Uri.parse(ApiKnowledgeAiAssistantUrl.createAssistant);
      final headers = ApiHeaders.getAIChatHeaders("", token);
      final body = jsonEncode(request.toJson());

      final response = await http.post(url, headers: headers, body: body);

      print("📩 response.statusCode: ${response.statusCode}");
      print("📩 response.body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AssistantResponse.fromJson(jsonDecode(response.body)['data']);
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
          headers: headers,
          body: body,
        );

        if (retryResponse.statusCode == 200 ||
            retryResponse.statusCode == 201) {
          return AssistantResponse.fromJson(
              jsonDecode(retryResponse.body)['data']);
        } else {
          DialogHelper.showError(
              'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
          return null;
        }
      } else {
        DialogHelper.showError(
            'Tạo trợ lý thất bại. Mã lỗi: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      DialogHelper.showError('Đã xảy ra lỗi: $e');
      return null;
    }
  }
}
