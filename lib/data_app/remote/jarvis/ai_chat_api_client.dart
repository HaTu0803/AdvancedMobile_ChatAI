import 'dart:convert';

import 'package:advancedmobile_chatai/core/config/api_headers.dart';
import 'package:advancedmobile_chatai/core/local_storage/base_preferences.dart';
import 'package:advancedmobile_chatai/data_app/model/jarvis/chat_model.dart';
import 'package:advancedmobile_chatai/data_app/model/jarvis/conversations_model.dart';
import 'package:advancedmobile_chatai/data_app/url_api/jarvis/ai_chat_url.dart';
import 'package:http/http.dart' as http;

class AiChatApiClient {
  Future<ConversationResponse> conversation(ConversationRequest params) async {
    String token = await BasePreferences().getTokenPreferred('access_token');
    final uri = Uri.parse(ApiJarvisAiChatUrl.getConversations).replace(
      queryParameters: params.toJson(),
    );

    final response = await http.get(
      uri,
      headers: ApiHeaders.getAIChatHeaders("", token),
    );
    print("📩 response.statusCode: ${response.statusCode}");
    print("📩 response.body params: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ConversationResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to sign up: ${response.body}');
    }
  }

  Future<ConversationHistoryResponse> getConversationsHistory(
      ConversationRequest params, String conversationId) async {
    String token = await BasePreferences().getTokenPreferred('access_token');
    final uri =
        Uri.parse(ApiJarvisAiChatUrl.getConversationHistory(conversationId))
            .replace(queryParameters: params.toJson());

    final response = await http.get(
      uri,
      headers: ApiHeaders.getAIChatHeaders("", token),
    );
    print("📩 response.statusCode: ${response.statusCode}");
    print("📩 response.body params: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ConversationHistoryResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to sign up: ${response.body}');
    }
  }

  Future<ChatWithBotResponse> chatWithBot(ChatRequest request) async {
    String token = await BasePreferences().getTokenPreferred('access_token');

    final response = await http.post(
      Uri.parse(ApiJarvisAiChatUrl.chatWithBot),
      headers: ApiHeaders.getAIChatHeaders("", token),
      body: jsonEncode(request.toJson()),
    );
    print("📩 response.statusCode: ${response.statusCode}");
    print("📩 response.body params: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ChatWithBotResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to sign up: ${response.body}');
    }
  }

  Future<ChatResponse> sendMessage(ChatRequest request) async {
    String token = await BasePreferences().getTokenPreferred('access_token');

    final response = await http.post(
      Uri.parse(ApiJarvisAiChatUrl.sendMessage),
      headers: ApiHeaders.getAIChatHeaders("", token),
      body: jsonEncode(request.toJson()),
    );
    print("📩 response.statusCode: ${response.statusCode}");
    print("📩 response.body params: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ChatResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to sign up: ${response.body}');
    }
  }
}
