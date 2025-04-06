import 'package:advancedmobile_chatai/core/local_storage/base_preferences.dart';
import 'package:advancedmobile_chatai/data_app/model/jarvis/history.dart';
import 'package:advancedmobile_chatai/data_app/remote/jarvis/ai_chat_api_client.dart';
import 'package:flutter/foundation.dart';

class AiChatRepository {
  // ignore: non_constant_identifier_names
  final AiChatApiClient AIChatApiClient = AiChatApiClient();
  final BasePreferences basePreferences = BasePreferences();

  Future<ConversationResponse> getConversations(
      ConversationRequest request) async {
    try {
      final accessToken =
          await basePreferences.getTokenPreferred('access_token');
      final response = await AIChatApiClient.conversation(request, accessToken);
      return response;
    } catch (e) {
      debugPrint("GetConversations Error: $e");
      rethrow;
    }
  }
}
