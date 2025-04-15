import 'dart:convert';

import 'package:advancedmobile_chatai/core/config/api_headers.dart';
import 'package:advancedmobile_chatai/core/helpers/dialog_helper.dart';
import 'package:advancedmobile_chatai/core/helpers/refresh_token_helper.dart';
import 'package:advancedmobile_chatai/core/local_storage/base_preferences.dart';
import 'package:advancedmobile_chatai/data_app/model/knowledge_base/assistant_model.dart';
import 'package:advancedmobile_chatai/data_app/url_api/knowledge_base/ai_assistant_url.dart';
import 'package:http/http.dart' as http;

class AssistantApiClient {
  Future<AssistantResponse> favoriteAssistant(assistantId) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    print("🔑 AccessToken: $token");

    final url =
        Uri.parse(ApiKnowledgeAiAssistantUrl.favoriteAssistant(assistantId));
    final headers = ApiHeaders.getAIChatHeaders("", token);
    final body = jsonEncode({
      'assistantId': assistantId,
    });

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

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return AssistantResponse.fromJson(
            jsonDecode(retryResponse.body)['data']);
      } else {
        DialogHelper.showError(
            'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      DialogHelper.showError(
          'Thao tác yêu thích thất bại. Mã lỗi: ${response.statusCode}');
      throw Exception(
          'Thao tác yêu thích thất bại. Mã lỗi: ${response.statusCode}');
    }
  }

  Future<AssistantResponse> createAssistant(Assistant request) async {
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
          throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
        }
      } else {
        DialogHelper.showError(
            'Tạo trợ lý thất bại. Mã lỗi: ${response.statusCode}');
        throw Exception('Tạo trợ lý thất bại. Mã lỗi: ${response.statusCode}');
      }
    } catch (e) {
      DialogHelper.showError('Đã xảy ra lỗi: $e');
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }

  Future<AssistantListResponse> getAssistantList() async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    print("🔑 AccessToken: $token");

    final url = Uri.parse(ApiKnowledgeAiAssistantUrl.getAssistants);
    final headers = ApiHeaders.getAIChatHeaders("", token);

    final response = await http.get(url, headers: headers);

    print("📩 response.statusCode: ${response.statusCode}");
    print("📩 response.body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AssistantListResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        headers: headers,
        body: null,
      );

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return AssistantListResponse.fromJson(jsonDecode(retryResponse.body));
      } else {
        DialogHelper.showError(
            'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      DialogHelper.showError(
          'Lấy danh sách trợ lý thất bại. Mã lỗi: ${response.statusCode}');
      throw Exception(
          'Lấy danh sách trợ lý thất bại. Mã lỗi: ${response.statusCode}');
    }
  }

  Future<AssistantResponse> updateAssistant(
      String assistantId, Assistant request) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    print("🔑 AccessToken: $token");

    final url =
        Uri.parse(ApiKnowledgeAiAssistantUrl.updateAssistant(assistantId));
    final headers = ApiHeaders.getAIChatHeaders("", token);
    final body = jsonEncode(request.toJson());

    final response = await http.patch(url, headers: headers, body: body);

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

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return AssistantResponse.fromJson(
            jsonDecode(retryResponse.body)['data']);
      } else {
        DialogHelper.showError(
            'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      DialogHelper.showError(
          'Cập nhật trợ lý thất bại. Mã lỗi: ${response.statusCode}');
      throw Exception(
          'Cập nhật trợ lý thất bại. Mã lỗi: ${response.statusCode}');
    }
  }

  Future<bool> deleteAssistant(String assistantId) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    print("🔑 AccessToken: $token");

    final url =
        Uri.parse(ApiKnowledgeAiAssistantUrl.deleteAssistant(assistantId));
    final headers = ApiHeaders.getAIChatHeaders("", token);

    final response = await http.delete(url, headers: headers);

    print("📩 response.statusCode: ${response.statusCode}");
    print("📩 response.body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        headers: headers,
        body: null,
      );

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return true;
      } else {
        DialogHelper.showError(
            'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      DialogHelper.showError(
          'Xóa trợ lý thất bại. Mã lỗi: ${response.statusCode}');
      throw Exception('Xóa trợ lý thất bại. Mã lỗi: ${response.statusCode}');
    }
  }

  Future<AssistantResponse> getAssistantById(String assistantId) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    print("🔑 AccessToken: $token");

    final url = Uri.parse(ApiKnowledgeAiAssistantUrl.getAssistant(assistantId));
    final headers = ApiHeaders.getAIChatHeaders("", token);

    final response = await http.get(url, headers: headers);

    print("📩 response.statusCode: ${response.statusCode}");
    print("📩 response.body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AssistantResponse.fromJson(jsonDecode(response.body)['data']);
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        headers: headers,
        body: null,
      );

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return AssistantResponse.fromJson(
            jsonDecode(retryResponse.body)['data']);
      } else {
        DialogHelper.showError(
            'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      DialogHelper.showError(
          'Lấy trợ lý thất bại. Mã lỗi: ${response.statusCode}');
      throw Exception('Lấy trợ lý thất bại. Mã lỗi: ${response.statusCode}');
    }
  }
}
