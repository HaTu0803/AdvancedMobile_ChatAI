import 'package:advancedmobile_chatai/data_base/url_api/root_url.dart';

const String baseUrl = AUTH_BASE_URL;

class ApiAuthUrl {
  static const String signUp = '$baseUrl/password/sign-up';
  static const String signIn = '$baseUrl/password/sign-in';
  static const String refreshToken = '$baseUrl/sessions/current/refresh';
  static const String logout = '$baseUrl/sessions/current';
}
