import 'package:advancedmobile_chatai/data_base/url_api/root_url.dart';

const String baseUrl = '$KNOWLEDGE_BASE_URL/knowledge';

class ApiKnowledgeBaseUrl {
  static const String createKnowledge = baseUrl;
  static String getKnowledges(String query) =>
      '$baseUrl/${query.isNotEmpty ? '?$query' : ''}';
  static String updateKnowledge(String id) => '$baseUrl/$id';
  static String deleteKnowledge(String id) => '$baseUrl/$id';

  static String getUnitsOfKnowledge(String id, String query) =>
      '$baseUrl/$id/units${query.isNotEmpty ? '?$query' : ''}';
}
