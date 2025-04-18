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

      final response = await http.post(url, headers: headers, body: body);

      print("📩 response.statusCode: ${response.statusCode}");
      print("📩 response.body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return KnowledgeResponse.fromJson(jsonDecode(response.body)['data']);
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
          headers: headers,
          body: body,
        );

        if (retryResponse.statusCode == 200 ||
            retryResponse.statusCode == 201) {
          return KnowledgeResponse.fromJson(
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
    } catch (e) {
      DialogHelper.showError('Đã xảy ra lỗi: $e');
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }

  Future<KnowledgeListResponse> getKnowledges(BaseQueryParams params) async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');
      print("🔑 AccessToken: $token");

      final url =
          Uri.parse(ApiKnowledgeBaseUrl.getKnowledges(params.toQueryString()));
      final headers = ApiHeaders.getAIChatHeaders("", token);

      final response = await http.get(url, headers: headers);

      print("📩 response.statusCode: ${response.statusCode}");
      print("📩 response.body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return KnowledgeListResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
          headers: headers,
          body: null,
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
        DialogHelper.showError('Lỗi: ${response.statusCode}');
        throw Exception('Lỗi: ${response.statusCode}');
      }
    } catch (e) {
      DialogHelper.showError('Đã xảy ra lỗi: $e');
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }

  Future<KnowledgeListResponse> updateKnowledge(
      String id, Knowledge request) async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');
      print("🔑 AccessToken: $token");

      final url = Uri.parse(ApiKnowledgeBaseUrl.updateKnowledge(id));
      final headers = ApiHeaders.getAIChatHeaders("", token);
      final body = jsonEncode(request.toJson());
      final response = await http.patch(url, headers: headers, body: body);

      print("📩 response.statusCode: ${response.statusCode}");
      print("📩 response.body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return KnowledgeListResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
          headers: headers,
          body: body,
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
        DialogHelper.showError('Lỗi: ${response.statusCode}');
        throw Exception('Lỗi: ${response.statusCode}');
      }
    } catch (e) {
      DialogHelper.showError('Đã xảy ra lỗi: $e');
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }

  Future<bool> deleteKnowledge(String id) async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');
      print("🔑 AccessToken: $token");

      final url = Uri.parse(ApiKnowledgeBaseUrl.deleteKnowledge(id));
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

        if (retryResponse.statusCode == 200 ||
            retryResponse.statusCode == 201) {
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
    } catch (e) {
      DialogHelper.showError('Đã xảy ra lỗi: $e');
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }

  Future<UnitsOfKnowledgeListResponse> getUnitsOfKnowledge(
      BaseQueryParams params, String id) async {
    try {
      await BasePreferences.init();
      String token = await BasePreferences().getTokenPreferred('access_token');
      print("🔑 AccessToken: $token");

      final url = Uri.parse(
          ApiKnowledgeBaseUrl.getUnitsOfKnowledge(params.toQueryString(), id));
      final headers = ApiHeaders.getAIChatHeaders("", token);

      final response = await http.get(url, headers: headers);

      print("📩 response.statusCode: ${response.statusCode}");
      print("📩 response.body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UnitsOfKnowledgeListResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        final retryResponse = await retryWithRefreshToken(
          url: url,
          headers: headers,
          body: null,
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
        DialogHelper.showError('Lỗi: ${response.statusCode}');
        throw Exception('Lỗi: ${response.statusCode}');
      }
    } catch (e) {
      DialogHelper.showError('Đã xảy ra lỗi: $e');
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }
}
