import 'package:advancedmobile_chatai/data_app/model/jarvis/chat_model.dart';
import 'package:advancedmobile_chatai/data_app/model/jarvis/conversations_model.dart';
import 'package:advancedmobile_chatai/data_app/remote/jarvis/ai_chat_api_client.dart';
import 'package:flutter/foundation.dart';

class AiChatRepository {
  final AiChatApiClient AIChatApiClient = AiChatApiClient();

  Future<ConversationResponse> getConversations(
      ConversationRequest params) async {
    try {
      final response = await AIChatApiClient.conversation(params);
      return response;
    } catch (e) {
      debugPrint("GetConversations Error: $e");
      rethrow;
    }
  }

  Future<ConversationHistoryResponse> getConversationsHistory(
      ConversationRequest params, String conversationId) async {
    try {
      final response =
          await AIChatApiClient.getConversationsHistory(params, conversationId);
      return response;
    } catch (e) {
      debugPrint("GetConversationsHistory Error: $e");
      rethrow;
    }
  }

  Future<ChatWithBotResponse> chatWithBot(ChatRequest request) async {
    try {
      final response = await AIChatApiClient.chatWithBot(request);
      return response;
    } catch (e) {
      debugPrint("ChatWithBot Error: $e");
      rethrow;
    }
  }

  Future<ChatResponse> sendMessage(ChatRequest request) async {
    try {
      final response = await AIChatApiClient.sendMessage(request);
      return response;
    } catch (e) {
      debugPrint("SendMessage Error: $e");
      rethrow;
    }
  }
}
