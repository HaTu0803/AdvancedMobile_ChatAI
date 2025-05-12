import 'dart:convert';

import 'package:advancedmobile_chatai/core/config/api_headers.dart';
import 'package:advancedmobile_chatai/core/helpers/dialog_helper.dart';
import 'package:advancedmobile_chatai/core/helpers/refresh_token_helper.dart';
import 'package:advancedmobile_chatai/core/local_storage/base_preferences.dart';
import 'package:advancedmobile_chatai/core/navigation/routes.dart';
import 'package:advancedmobile_chatai/data_app/model/jarvis/upload_image_model.dart';
import 'package:advancedmobile_chatai/data_app/repository/auth/authentication_repository.dart';
import 'package:advancedmobile_chatai/data_app/url_api/jarvis/upload_image_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UploadImageApiClient {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<UploadImageResponse> uploadImage(UploadImage request) async {
     await BasePreferences.init();
     String token = await BasePreferences().getTokenPreferred('access_token');
      final url = Uri.parse(ApiUploadImagetUrl.upload);
      final headers = ApiHeaders.getAIChatHeaders("", token);
      print("URL: $url");
      print("Headers: $headers");
      print("Token: $token");
      print("Request body: ${request.toJson()}");
      print("Request body: ${jsonEncode(request.toJson())}");
    final body = jsonEncode(request.toJson());
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return UploadImageResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        body: body,
        method: 'POST',
      );

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return UploadImageResponse.fromJson(jsonDecode(retryResponse.body));
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
    
  }

    Future<UploadImageSuccessResponse> uploadImageSuccess(UploadImage request) async {
     await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
      final url = Uri.parse(ApiUploadImagetUrl.uploadSucces);
      final headers = ApiHeaders.getAIChatHeaders("", token);
    final body = jsonEncode(request.toJson());
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return UploadImageSuccessResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        body: body,
        method: 'POST',
      );

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return UploadImageSuccessResponse.fromJson(jsonDecode(retryResponse.body));
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
    
  }
}