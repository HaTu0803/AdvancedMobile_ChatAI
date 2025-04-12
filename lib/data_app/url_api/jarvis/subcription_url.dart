import 'package:advancedmobile_chatai/data_base/url_api/root_url.dart';

const String baseUrl = JARVIS_BASE_URL;

class ApiJarvisSubscriptionUrl {
  static const String getUsage = '$baseUrl/subscriptions/me';
  static const String subscribe = '$baseUrl/subscriptions/subscribe';
}
