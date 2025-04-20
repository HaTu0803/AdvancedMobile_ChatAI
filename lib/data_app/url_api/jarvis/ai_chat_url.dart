import 'package:advancedmobile_chatai/data_base/url_api/root_url.dart';

const String baseUrl = JARVIS_BASE_URL;

class ApiJarvisAiChatUrl {
  static const String chatWithBot = '$baseUrl/messages';
  static String getConversations(String query)  =>
      '$baseUrl/conversations${query.isNotEmpty ? '?$query' : ''}';
  static const String sendMessage = '$baseUrl/messages';

  static String getConversationHistory(String conversationId) {
    return '$baseUrl/conversations/$conversationId/messages';
  }
}
