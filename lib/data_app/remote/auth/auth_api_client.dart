import 'dart:convert';

import 'package:advancedmobile_chatai/core/config/api_headers.dart';
import 'package:advancedmobile_chatai/data_app/model/auth/auth_model.dart';
import 'package:advancedmobile_chatai/data_app/url_api/auth/auth_url.dart';
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
    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to sign in');
    }
  }

  Future logOut(String token, String refreshToken) async {
    final response = await http.post(
      Uri.parse(ApiAuthUrl.logout),
      headers: ApiHeaders.getLogoutHeaders(token, refreshToken),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw Exception('Failed to sign out');
    }
  }

  // Khi token hết hạn, sử dụng refresh token để lấy token mới
  Future<AuthResponse> fetchRefreshToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse(ApiAuthUrl.refreshToken),
      headers: ApiHeaders.getRefreshHeaders(refreshToken),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to refresh token');
    }
  }
}
