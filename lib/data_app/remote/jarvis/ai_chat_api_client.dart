import 'dart:convert';

import 'package:advancedmobile_chatai/core/config/api_headers.dart';
import 'package:advancedmobile_chatai/data_app/model/jarvis/history.dart';
import 'package:advancedmobile_chatai/data_app/url_api/jarvis/ai_chat_url.dart';
import 'package:http/http.dart' as http;

class AiChatApiClient {
  Future<ConversationResponse> conversation(
      ConversationRequest request, String token) async {
    final uri = Uri.parse(ApiJarvisAiChatUrl.getConversations).replace(
      queryParameters: request.toJson(),
    );

    final response = await http.get(
      uri,
      headers: ApiHeaders.getAIChatHeaders(null, token),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ConversationResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to sign up: ${response.body}');
    }
  }
}
