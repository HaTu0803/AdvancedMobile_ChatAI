import 'package:advancedmobile_chatai/data_base/url_api/root_url.dart';

const String baseUrl = JARVIS_BASE_URL;

class ApiJarvisAiEmailUrl {
  static const String responseEmail = '$baseUrl/ai-email';
  static const String suggestReplyIdeas = '$baseUrl/ai-email/reply-ideas';
}
