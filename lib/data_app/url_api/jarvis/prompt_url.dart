import 'package:advancedmobile_chatai/data_base/url_api/root_url.dart';

const String baseUrl = PROMPT_BASE_URL;

class ApiJarvisPromptUrl {
  static String getPrompts(String query)  =>
      '$baseUrl/${query.isNotEmpty ? '?$query' : ''}';
  static const String createPrompt = '$baseUrl';

  static String updatePrompt(String id) => '$baseUrl/$id';
  static String deletePrompt(String id) => '$baseUrl/$id';
  static String addPromptToFavorites(String id) =>
      '$baseUrl/$id/favorite';
  static String removePromptFromFavorites(String id) =>
      '$baseUrl/$id/favorite';
  static const String getCategories = '$baseUrl/categories';
}
