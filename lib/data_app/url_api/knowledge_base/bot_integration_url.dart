import 'package:advancedmobile_chatai/data_base/url_api/root_url.dart';

const String baseUrl = '$KNOWLEDGE_BASE_URL/bot-integration';

class ApiBotIntegrationUrl {
  static String getConfigurations(String assistantId) => '$baseUrl/$assistantId/configurations';
  static String disconnectBotIntegration(String assistantId, String type) => '$baseUrl/$assistantId/$type';
  static const String verifyTelegramBotConfigure = '$baseUrl/telegram/validation';
  static String publishTelegramBot(String assistantId) => '$baseUrl/telegram/publish/$assistantId';
  static const String verifySlackBotConfigure = '$baseUrl/slack/validation';
  static String publishSlackBot(String assistantId) => '$baseUrl/slack/publish/$assistantId';
  static const String verifyMessengerBotConfigure = '$baseUrl/messenger/validation';
  static String publishMessengerBot(String assistantId) => '$baseUrl/messenger/publish/$assistantId';
}