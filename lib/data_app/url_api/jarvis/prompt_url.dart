import 'package:advancedmobile_chatai/data_base/url_api/root_url.dart';

const String baseUrl = JARVIS_BASE_URL;

class ApiJarvisPromptUrl {
  static const String getPrompts = '$baseUrl/prompts';
  static const String createPrompt = '$baseUrl/prompts';

  static String updatePrompt(String id) => '$baseUrl/prompts/$id';
  static String deletePrompt(String id) => '$baseUrl/prompts/$id';
  static String addPromptToFavorites(String id) =>
      '$baseUrl/prompts/$id/favorite';
  static String removePromptFromFavorites(String id) =>
      '$baseUrl/prompts/$id/favorite';
}
