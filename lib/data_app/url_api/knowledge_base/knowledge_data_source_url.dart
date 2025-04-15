import 'package:advancedmobile_chatai/data_base/url_api/root_url.dart';

const String baseUrl = '$KNOWLEDGE_BASE_URL/knowledge';

class ApiKnowledgeDataSourceUrl {
  static String uploadLocal(String id) => '$baseUrl/$id/local-file';
  static String uploadGgDrive(String id) => '$baseUrl/$id/google-drive';
  static String uploadSlack(String id) => '$baseUrl/$id/slack';
  static String uploadConfluence(String id) => '$baseUrl/$id/confluence';
  static String uploadWeb(String id) => '$baseUrl/$id/web';
}
