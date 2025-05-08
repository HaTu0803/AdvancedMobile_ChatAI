import 'dart:convert';

import 'package:advancedmobile_chatai/core/config/api_headers.dart';
import 'package:advancedmobile_chatai/core/helpers/dialog_helper.dart';
import 'package:advancedmobile_chatai/core/helpers/refresh_token_helper.dart';
import 'package:advancedmobile_chatai/core/local_storage/base_preferences.dart';
import 'package:advancedmobile_chatai/data_app/model/base/base_model.dart';
import 'package:advancedmobile_chatai/data_app/model/knowledge_base/knowledge_model.dart';
import 'package:advancedmobile_chatai/data_app/url_api/knowledge_base/knowledge_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../core/navigation/routes.dart';
import '../../repository/auth/authentication_repository.dart';

class KnowledgeApiClient {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<KnowledgeResponse> createKnowledge(Knowledge request) async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');
      print("🔑 AccessToken: $token");

      final url = Uri.parse(ApiKnowledgeBaseUrl.createKnowledge);
      final headers = ApiHeaders.getAIChatHeaders("", token);
      final body = jsonEncode(request.toJson());
      
      print("📤 Request body: $body");
      final response = await http.post(url, headers: headers, body: body);
      print("📥 Response status: ${response.statusCode}");
      print("📥 Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        print("📥 Parsed response body: $responseBody");
        
        if (responseBody is Map<String, dynamic>) {
          // Try to handle both possible response formats
          if (responseBody.containsKey('data')) {
            return KnowledgeResponse.fromJson(responseBody['data']);
          } else if (responseBody.containsKey('knowledgeName')) {
            // If the response is the knowledge object directly
            return KnowledgeResponse.fromJson(responseBody);
          }
        }
        throw Exception('Invalid response format from server: $responseBody');
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
          body: body,
          method: 'POST',
        );

        if (retryResponse.statusCode == 200 ||
            retryResponse.statusCode == 201) {
          return KnowledgeResponse.fromJson(jsonDecode(retryResponse.body));
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
        throw Exception('Failed to upload file due to an error response');
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }

  Future<KnowledgeListResponse> getKnowledges(BaseQueryParams params) async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');

      final url =
          Uri.parse(ApiKnowledgeBaseUrl.getKnowledges(params.toQueryString()));
      final headers = ApiHeaders.getAIChatHeaders("", token);

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return KnowledgeListResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
          body: null,
          method: 'GET',
        );

        if (retryResponse.statusCode == 200 ||
            retryResponse.statusCode == 201) {
          return KnowledgeListResponse.fromJson(jsonDecode(retryResponse.body));
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
        throw Exception('Failed to upload file due to an error response');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<KnowledgeListResponse> updateKnowledge(
      String id, Knowledge request) async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');

      final url = Uri.parse(ApiKnowledgeBaseUrl.updateKnowledge(id));
      final headers = ApiHeaders.getAIChatHeaders("", token);
      final body = jsonEncode(request.toJson());
      final response = await http.patch(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return KnowledgeListResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
          body: body,
          method: 'PATCH',
        );

        if (retryResponse.statusCode == 200 ||
            retryResponse.statusCode == 201) {
          return KnowledgeListResponse.fromJson(jsonDecode(retryResponse.body));
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
        throw Exception('Failed to upload file due to an error response');
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }

  Future<bool> deleteKnowledge(String id) async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');

      final url = Uri.parse(ApiKnowledgeBaseUrl.deleteKnowledge(id));
      final headers = ApiHeaders.getAIChatHeaders("", token);
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
          method: 'DELETE',
        );

        if (retryResponse.statusCode == 200 ||
            retryResponse.statusCode == 201 ||
            retryResponse.statusCode == 204) {
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
        handleErrorResponse(response);
        throw Exception('Failed to delete knowledge base');
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }

  Future<UnitsOfKnowledgeListResponse> getUnitsOfKnowledge(
      String id, BaseQueryParams params) async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');

      final url = Uri.parse(
          ApiKnowledgeBaseUrl.getUnitsOfKnowledge(id, params.toQueryString()));
      final headers = ApiHeaders.getAIChatHeaders("", token);

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UnitsOfKnowledgeListResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
          body: null,
          method: 'GET',
        );

        if (retryResponse.statusCode == 200 ||
            retryResponse.statusCode == 201) {
          return UnitsOfKnowledgeListResponse.fromJson(
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
        handleErrorResponse(response);
        throw Exception('Failed to upload file due to an error response');
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }
}
