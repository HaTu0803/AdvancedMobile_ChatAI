import 'dart:convert';

import 'package:advancedmobile_chatai/core/config/api_headers.dart';
import 'package:advancedmobile_chatai/data_app/model/auth/auth_model.dart';
import 'package:advancedmobile_chatai/data_app/url_api/auth/auth_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AuthApiClient {
  Future<AuthResponse> signUp(SignUpRequest request) async {
    final response = await http.post(
      Uri.parse(ApiAuthUrl.signUp),
      headers: ApiHeaders.defaultHeaders,
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to sign up');
    }
  }

  Future<AuthResponse> signIn(SignInRequest request) async {
    final response = await http.post(
      Uri.parse(ApiAuthUrl.signIn),
      headers: ApiHeaders.defaultHeaders,
      body: jsonEncode(request.toJson()),
    );
    debugPrint("📩 API Response: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to sign in');
    }
  }

  Future<void> logOut(String token, String refreshToken) async {
    if (token.isEmpty || refreshToken.isEmpty) {
      throw Exception('Token or refresh token is missing');
    }
    final response = await http.delete(
      Uri.parse(ApiAuthUrl.logout),
      headers: ApiHeaders.getLogoutHeaders(token, refreshToken),
      body: jsonEncode({}), // Gửi JSON rỗng
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint("✅ Logout thành công!");
    } else {
      throw Exception('Failed to sign out');
    }
  }

  // Khi token hết hạn, sử dụng refresh token để lấy token mới
  Future<String> fetchRefreshToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse(ApiAuthUrl.refreshToken),
      headers: ApiHeaders.getRefreshHeaders(refreshToken),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthResponse.fromJson(jsonDecode(response.body))
          .accessToken; // Trả về access token mới
    } else {
      throw Exception('Failed to refresh token');
    }
  }
}
