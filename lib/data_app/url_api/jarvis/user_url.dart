import 'package:advancedmobile_chatai/data_base/url_api/root_url.dart';

const String baseUrl = JARVIS_BASE_URL;

class ApiJarvisUserUrl {
  static const String getCurrentUser = '$baseUrl/auth/me';
}
