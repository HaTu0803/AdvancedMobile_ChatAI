import 'package:advancedmobile_chatai/data_app/model/base/base_model.dart';
import 'package:advancedmobile_chatai/data_app/model/knowledge_base/assistant_model.dart';
import 'package:advancedmobile_chatai/data_app/remote/knowledge_base/ai_assistant_remote.dart';
import 'package:flutter/material.dart';

class AssistantRepository {
  final AssistantApiClient AssistantApi = AssistantApiClient();

  Future<AssistantResponse> favoriteAssistant(assistantId) async {
    try {
      final response = await AssistantApi.favoriteAssistant(assistantId);
      return response;
    } catch (e) {
      debugPrint("GetConversations Error: $e");
      rethrow;
    }
  }

  Future<AssistantResponse> createAssistant(Assistant request) async {
    try {
      final response = await AssistantApi.createAssistant(request);
      return response;
    } catch (e) {
      debugPrint("GetConversations Error: $e");
      rethrow;
    }
  }

  Future<AssistantListResponse> getAssistants(BaseQueryParams? params) async {
    try {
      final response = await AssistantApi.getAssistantList(params);
      return response;
    } catch (e) {
      debugPrint("getAssistants Error: $e");
      rethrow;
    }
  }

  Future<AssistantResponse> updateAssistant(
      String assistantId, Assistant request) async {
    try {
      final response = await AssistantApi.updateAssistant(assistantId, request);
      return response;
    } catch (e) {
      debugPrint("GetConversations Error: $e");
      rethrow;
    }
  }

  Future<bool> deleteAssistant(String assistantId) async {
    try {
      final response = await AssistantApi.deleteAssistant(assistantId);
      return response;
    } catch (e) {
      debugPrint("GetConversations Error: $e");
      rethrow;
    }
  }

  Future<AssistantResponse> getAssistant(String assistantId) async {
    try {
      final response = await AssistantApi.getAssistantById(assistantId);
      return response;
    } catch (e) {
      debugPrint("GetConversations Error: $e");
      rethrow;
    }
  }

  Future<bool> importKnowledge(KnowledgeToAssistant params) async {
    try {
      final response = await AssistantApi.importKnowledge(params);
      return response;
    } catch (e) {
      debugPrint("GetConversations Error: $e");
      rethrow;
    }
  }

  Future<bool> removeKnowledge(KnowledgeToAssistant params) async {
    try {
      final response = await AssistantApi.removeKnowledge(params);
      return response;
    } catch (e) {
      debugPrint("GetConversations Error: $e");
      rethrow;
    }
  }

  Future<KnowledgeAssistantListResponse> getImportKnowledgeList(
      String assistantId, BaseQueryParams params) async {
    try {
      final response =
          await AssistantApi.getImportKnowledgeList(assistantId, params);
      return response;
    } catch (e) {
      debugPrint("GetConversations Error: $e");
      rethrow;
    }
  }

  // Future<ThreadAssistantResponse> createThread(ThreadAssistant request) async {
  //   try {
  //     final response = await AssistantApi.createThread(request);
  //     return response;
  //   } catch (e) {
  //     debugPrint("GetConversations Error: $e");
  //     rethrow;
  //   }
  // }

  // Future<bool> updateThreadBackground(ThreadAssistant request) async {
  //   try {
  //     final response = await AssistantApi.updateThreadBackground(request);
  //     return response;
  //   } catch (e) {
  //     debugPrint("GetConversations Error: $e");
  //     rethrow;
  //   }
  // }

  Future<dynamic> askAssistant(String assistantId, AskAssistant request) async {
    try {
      
      final response = await AssistantApi.askAssistant(assistantId, request);
      return response;
    } catch (e) {
      debugPrint("askAssistant Error: $e");
      rethrow;
    }
  }

  // Future<List<RetrieveMessageOfThreadResponse>> retrieveMessageOfThread(
  //     String openAiThreadId) async {
  //   try {
  //     final response =
  //         await AssistantApi.retrieveMessageOfThread(openAiThreadId);
  //     return response;
  //   } catch (e) {
  //     debugPrint("GetConversations Error: $e");
  //     rethrow;
  //   }
  // }

  // Future<ThreadAssistantListResponse> getThreads(
  //     String assistantId, BaseQueryParams params) async {
  //   try {
  //     final response = await AssistantApi.getThreads(assistantId, params);
  //     return response;
  //   } catch (e) {
  //     debugPrint("GetConversations Error: $e");
  //     rethrow;
  //   }
  // }
}
