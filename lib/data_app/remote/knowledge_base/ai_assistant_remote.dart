import 'dart:convert';

import 'package:advancedmobile_chatai/core/config/api_headers.dart';
import 'package:advancedmobile_chatai/core/helpers/dialog_helper.dart';
import 'package:advancedmobile_chatai/core/helpers/refresh_token_helper.dart';
import 'package:advancedmobile_chatai/core/local_storage/base_preferences.dart';
import 'package:advancedmobile_chatai/data_app/model/base/base_model.dart';
import 'package:advancedmobile_chatai/data_app/model/knowledge_base/assistant_model.dart';
import 'package:advancedmobile_chatai/data_app/url_api/knowledge_base/ai_assistant_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../core/navigation/routes.dart';
import '../../repository/auth/authentication_repository.dart';

class AssistantApiClient {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
      return AssistantResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        headers: headers,
        body: body,
      );

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return AssistantResponse.fromJson(jsonDecode(retryResponse.body));
      } else {
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['error'] ?? 'Đã xảy ra lỗi không xác định';

      DialogHelper.showError(errorMessage);
      throw Exception('Lỗi: $errorMessage');
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
        return AssistantResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
          headers: headers,
          body: body,
        );

        if (retryResponse.statusCode == 200 ||
            retryResponse.statusCode == 201) {
          return AssistantResponse.fromJson(jsonDecode(retryResponse.body));
        } else {
          await AuthRepository().logOut();
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            AppRoutes.login,
            (route) => false,
          );
          throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
        }
      } else {
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => false,
        );

        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error'] ?? 'Đã xảy ra lỗi không xác định';

        DialogHelper.showError(errorMessage);
        throw Exception('Lỗi: $errorMessage');
      }
    } catch (e) {
      DialogHelper.showError('Đã xảy ra lỗi: $e');
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }

  Future<AssistantListResponse> getAssistantList(
      BaseQueryParams? params) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    print("🔑 AccessToken: $token");

    final url = Uri.parse(ApiKnowledgeAiAssistantUrl.getAssistants(
        params?.toQueryString() ?? ""));
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
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => false,
        );
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['error'] ?? 'Đã xảy ra lỗi không xác định';

      DialogHelper.showError(errorMessage);
      throw Exception('Lỗi: $errorMessage');
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
      return AssistantResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        headers: headers,
        body: body,
      );

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return AssistantResponse.fromJson(jsonDecode(retryResponse.body));
      } else {
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['error'] ?? 'Đã xảy ra lỗi không xác định';

      DialogHelper.showError(errorMessage);
      throw Exception('Lỗi: $errorMessage');
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
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['error'] ?? 'Đã xảy ra lỗi không xác định';

      DialogHelper.showError(errorMessage);
      throw Exception('Lỗi: $errorMessage');
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
    print("📩 response.b:ody: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AssistantResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        headers: headers,
        body: null,
      );

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return AssistantResponse.fromJson(jsonDecode(retryResponse.body));
      } else {
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['error'] ?? 'Đã xảy ra lỗi không xác định';

      DialogHelper.showError(errorMessage);
      throw Exception('Lỗi: $errorMessage');
    }
  }

  Future<bool> importKnowledge(KnowledgeToAssistant params) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    print("🔑 AccessToken: $token");

    final url = Uri.parse(ApiKnowledgeAiAssistantUrl.importKnowledgeToAssistant(
        params.knowledgeId, params.assistantId));
    final headers = ApiHeaders.getAIChatHeaders("", token);

    final response = await http.post(url, headers: headers);

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
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['error'] ?? 'Đã xảy ra lỗi không xác định';

      DialogHelper.showError(errorMessage);
      throw Exception('Lỗi: $errorMessage');
    }
  }

  Future<bool> removeKnowledge(KnowledgeToAssistant params) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    print("🔑 AccessToken: $token");

    final url = Uri.parse(
        ApiKnowledgeAiAssistantUrl.removeKnowledgeFromAssistant(
            params.knowledgeId, params.assistantId));
    final headers = ApiHeaders.getAIChatHeaders("", token);

    final response = await http.post(url, headers: headers);

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
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['error'] ?? 'Đã xảy ra lỗi không xác định';

      DialogHelper.showError(errorMessage);
      throw Exception('Lỗi: $errorMessage');
    }
  }

  Future<KnowledgeAssistantListResponse> getImportKnowledgeList(
    String assistantId,
    BaseQueryParams params,
  ) async {
    await BasePreferences.init();
    final token = await BasePreferences().getTokenPreferred('access_token');
    print("🔑 AccessToken: $token");

    final url = Uri.parse(
      ApiKnowledgeAiAssistantUrl.getImportedKnowledgeInAssistant(
        assistantId,
        params.toQueryString(),
      ),
    );

    final headers = ApiHeaders.getAIChatHeaders("", token);
    final response = await http.get(url, headers: headers);

    print("📩 response.statusCode: ${response.statusCode}");
    print("📩 response.body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return KnowledgeAssistantListResponse.fromJson(
        jsonDecode(response.body),
      );
    }

    if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        headers: headers,
        body: null,
      );

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return KnowledgeAssistantListResponse.fromJson(
          jsonDecode(retryResponse.body),
        );
      } else {
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['error'] ?? 'Đã xảy ra lỗi không xác định';

      DialogHelper.showError(errorMessage);
      throw Exception('Lỗi: $errorMessage');
    }
  }

  Future<ThreadAssistantResponse> createThread(ThreadAssistant request) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    final url = Uri.parse(ApiKnowledgeAiAssistantUrl.createThreadForAssistant);
    final headers = ApiHeaders.getAIChatHeaders("", token);
    final body = jsonEncode(request.toJson());
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ThreadAssistantResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        headers: headers,
        body: body,
      );

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return ThreadAssistantResponse.fromJson(jsonDecode(retryResponse.body));
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

  Future<bool> updateThreadBackground(ThreadAssistant request) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    final url = Uri.parse(ApiKnowledgeAiAssistantUrl.updateThreadBackground);
    final headers = ApiHeaders.getAIChatHeaders("", token);
    final body = jsonEncode(request.toJson());
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        headers: headers,
        body: body,
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
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['error'] ?? 'Đã xảy ra lỗi không xác định';

      DialogHelper.showError(errorMessage);
      throw Exception('Lỗi: $errorMessage');
    }
  }

  Future<bool> askAssistant(String assistantId, AskAssistant request) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    print("🔑 AccessToken: $token");

    final url = Uri.parse(ApiKnowledgeAiAssistantUrl.askAssistant(assistantId));
    final headers = ApiHeaders.getAIChatHeaders("", token);
    final body = jsonEncode(request.toJson());

    final response = await http.post(url, headers: headers, body: body);

    print("📩 response.statusCode: ${response.statusCode}");
    print("📩 response.body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        headers: headers,
        body: body,
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
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['error'] ?? 'Đã xảy ra lỗi không xác định';

      DialogHelper.showError(errorMessage);
      throw Exception('Lỗi: $errorMessage');
    }
  }

  Future<List<RetrieveMessageOfThreadResponse>> retrieveMessageOfThread(
      String openAiThreadId) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    print("🔑 AccessToken: $token");

    final url = Uri.parse(
        ApiKnowledgeAiAssistantUrl.retrieveMessageOfThread(openAiThreadId));
    final headers = ApiHeaders.getAIChatHeaders("", token);

    final response = await http.get(url, headers: headers);

    print("📩 response.statusCode: ${response.statusCode}");
    print("📩 response.body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((e) => RetrieveMessageOfThreadResponse.fromJson(e))
          .toList();
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        headers: headers,
        body: null,
      );

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        final List<dynamic> data = jsonDecode(retryResponse.body);
        return data
            .map((e) => RetrieveMessageOfThreadResponse.fromJson(e))
            .toList();
      } else {
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['error'] ?? 'Đã xảy ra lỗi không xác định';

      DialogHelper.showError(errorMessage);
      throw Exception('Lỗi: $errorMessage');
    }
  }

  Future<ThreadAssistantListResponse> getThreads(
      String assistantId, BaseQueryParams params) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    print("🔑 AccessToken: $token");

    final url = Uri.parse(ApiKnowledgeAiAssistantUrl.getAssistantThreads(
        assistantId, params.toQueryString()));
    final headers = ApiHeaders.getAIChatHeaders("", token);

    final response = await http.get(url, headers: headers);

    print("📩 response.statusCode: ${response.statusCode}");
    print("📩 response.body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ThreadAssistantListResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        headers: headers,
        body: null,
      );
      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return ThreadAssistantListResponse.fromJson(
            jsonDecode(retryResponse.body));
      } else {
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      }
    } else {
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['error'] ?? 'Đã xảy ra lỗi không xác định';

      DialogHelper.showError(errorMessage);
      throw Exception('Lỗi: $errorMessage');
    }
  }
}
