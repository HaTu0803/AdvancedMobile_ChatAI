import 'package:advancedmobile_chatai/data_base/url_api/root_url.dart';

const String baseUrl = '$KNOWLEDGE_BASE_URL/ai-assistant';

class ApiKnowledgeAiAssistantUrl {
  static String favoriteAssistant(String assistantId) =>
      '$baseUrl/$assistantId/favorite';

  static const String createAssistant = baseUrl;
  static const String getAssistants = baseUrl;
  static String updateAssistant(String assistantId) => '$baseUrl/$assistantId';
  static String deleteAssistant(String assistantId) => '$baseUrl/$assistantId';

  static String getAssistant(String assistantId) => '$baseUrl/$assistantId';

  static String importKnowledgeToAssistant(
          String knowledgeId, String assistantId) =>
      '$baseUrl/$assistantId/knowledge/$knowledgeId';
  static String removeKnowledgeFromAssistant(
          String knowledgeId, String assistantId) =>
      '$baseUrl/$assistantId/knowledge/$knowledgeId';

  static String getImportedKnowledgeInAssistant(String assistantId) =>
      '$baseUrl/$assistantId/knowledge';

  static const String createThreadForAssistant = '$baseUrl/thread';
  static const String updateThreadBackground = '$baseUrl/thread/background';
  static String askAssistant(String assistantId) => '$baseUrl/$assistantId/ask';
  static String retrieveMessageOfThread(String openAiThreadId) =>
      '$baseUrl/thread/$openAiThreadId/messages';
  static String getAssistantThreads(String assistantId) =>
      '$baseUrl/$assistantId/threads';
}
