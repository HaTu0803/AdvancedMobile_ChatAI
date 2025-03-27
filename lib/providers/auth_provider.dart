import 'package:advancedmobile_chatai/core/local_storage/base_preferences.dart';
import 'package:advancedmobile_chatai/data_app/model/auth/auth_model.dart';
import 'package:advancedmobile_chatai/data_app/remote/auth/auth_api_client.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final AuthApiClient _authApiClient = AuthApiClient();
  final BasePreferences _basePreferences = BasePreferences();

  Future<bool> signUp(String email, String password) async {
    try {
      final response = await _authApiClient.signUp(SignUpRequest(
        email: email,
        password: password,
      ));
      await _basePreferences.setTokenPreferred(
          'access_token', response.accessToken);
      await _basePreferences.setTokenPreferred(
          'refresh_token', response.refreshToken);
      return true;
    } catch (e) {
      print("SignUp Error: $e");
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      final response = await _authApiClient.signIn(SignInRequest(
        email: email,
        password: password,
      ));

      await _basePreferences.setTokenPreferred(
          'access_token', response.accessToken);
      await _basePreferences.setTokenPreferred(
          'refresh_token', response.refreshToken);

      return true;
    } catch (e) {
      print("SignIn Error: $e");
      return false;
    }
  }

  Future<bool> logOut() async {
    try {
      final accessToken =
          await _basePreferences.getTokenPreferred('access_token');
      final refreshToken =
          await _basePreferences.getTokenPreferred('refresh_token');

      await _authApiClient.logOut(accessToken, refreshToken);

      // Xóa token khỏi SharedPreferences
      await _basePreferences.removeTokenPreferred('access_token');
      await _basePreferences.removeTokenPreferred('refresh_token');

      return true;
    } catch (e) {
      print("LogOut Error: $e");
      return false;
    }
  }

  Future<bool> hasSeenIntro() async {
    final seen = await _basePreferences.getTokenPreferred('seen_intro');
    return seen == 'true';
  }

  Future<void> setSeenIntro() async {
    await _basePreferences.setTokenPreferred('seen_intro', 'true');
  }

  Future<bool> isAuthenticated() async {
    final accessToken =
        await _basePreferences.getTokenPreferred('access_token');
    return accessToken.isNotEmpty;
  }
}
