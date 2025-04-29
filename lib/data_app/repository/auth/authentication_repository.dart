import 'package:advancedmobile_chatai/core/local_storage/base_preferences.dart';
import 'package:advancedmobile_chatai/data_app/model/auth/auth_model.dart';
import 'package:advancedmobile_chatai/data_app/remote/auth/auth_api_client.dart';
import 'package:flutter/foundation.dart';

class AuthRepository {
  final AuthApiClient authApiClient = AuthApiClient();
  final BasePreferences basePreferences = BasePreferences();

  Future<AuthResponse> signUp(SignUpRequest request) async {
    try {
      final response = await authApiClient.signUp(request);
      await saveTokens(response.accessToken, response.refreshToken);
      return response;
    } catch (e) {
      debugPrint("SignUp Error: ${e.toString()}");
      rethrow;
    }
  }

  Future<AuthResponse> signIn(SignInRequest request) async {
    try {
      final response = await authApiClient.signIn(request);
      await saveTokens(response.accessToken, response.refreshToken);
      return response;
    } catch (e) {
      debugPrint("SignIn Error: ${e.toString()}");
      rethrow;
    }
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await basePreferences.setTokenPreferred('access_token', accessToken);
    await basePreferences.setTokenPreferred('refresh_token', refreshToken);
  }

  Future<void> logOut() async {
    try {
      final accessToken =
          await basePreferences.getTokenPreferred('access_token');
      final refreshToken =
          await basePreferences.getTokenPreferred('refresh_token');

      if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
        await authApiClient.logOut(accessToken, refreshToken);
      }

      await basePreferences.clearTokens();
    } catch (e) {
      debugPrint("LogOut Error: $e");
      rethrow;
    }
  }

  Future<String> fetchRefreshToken() async {
    try {
      final refreshToken =
          await basePreferences.getTokenPreferred('refresh_token');
      if (refreshToken.isNotEmpty) {
        final response = await authApiClient.fetchRefreshToken(refreshToken);
        debugPrint("🔍 response Token: $response");

        return response;
      }
      debugPrint("Refresh token is empty: $refreshToken");
      throw Exception('Refresh token is empty');
    } catch (e) {
      debugPrint("Fetch Refresh Token Error: $e");
      rethrow;
    }
  }

  Future<bool> isAuthenticated() async {
    final accessToken = await basePreferences.getTokenPreferred('access_token');
    debugPrint("🔍 Access Token: $accessToken");
    return accessToken.isNotEmpty;
  }
}
