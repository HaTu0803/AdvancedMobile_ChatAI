import 'package:advancedmobile_chatai/data_base/url_api/root_url.dart';

const String baseUrl = '$KNOWLEDGE_BASE_URL/knowledge';

class ApiKnowledgeBaseUrl {
  static const String createKnowledge = baseUrl;
  static const String getKnowledges = baseUrl;
  static String updateKnowledge(String id) => '$baseUrl/$id';
  static String deleteKnowledge(String id) => '$baseUrl/$id';

  static String getUnitsOfKnowledge(String id) => '$baseUrl/$id/units';
}
