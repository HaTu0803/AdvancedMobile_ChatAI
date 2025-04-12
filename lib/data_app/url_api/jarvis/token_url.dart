import 'package:advancedmobile_chatai/data_base/url_api/root_url.dart';

const String baseUrl = JARVIS_BASE_URL;

class ApiJarvisTokenUrl {
  static const String getUsage = '$baseUrl/tokens/usage';
  static const String subscribe = '$baseUrl/subscriptions/subscribe';
}
