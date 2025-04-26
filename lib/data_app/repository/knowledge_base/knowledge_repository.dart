import 'package:advancedmobile_chatai/data_app/model/base/base_model.dart';
import 'package:advancedmobile_chatai/data_app/model/knowledge_base/knowledge_model.dart';
import 'package:advancedmobile_chatai/data_app/remote/knowledge_base/knowledge_remote.dart';
import 'package:flutter/material.dart';

class KnowledgeRepository {
  final KnowledgeApiClient KnowledgeApi = KnowledgeApiClient();

  Future<KnowledgeResponse> createKnowledge(Knowledge request) async {
    try {
      final response = await KnowledgeApi.createKnowledge(request);
      return response;
    } catch (e) {
      debugPrint("GetConversations Error: $e");
      rethrow;
    }
  }

  Future<KnowledgeListResponse> getKnowledges(BaseQueryParams params) async {
    try {
      final response = await KnowledgeApi.getKnowledges(params);
      return response;
    } catch (e) {
      debugPrint("GetConversations Error: $e");
      rethrow;
    }
  }

  Future<KnowledgeListResponse> updateKnowledge(
      String id, Knowledge request) async {
    try {
      final response = await KnowledgeApi.updateKnowledge(id, request);
      return response;
    } catch (e) {
      debugPrint("GetConversations Error: $e");
      rethrow;
    }
  }

  Future<bool> deleteKnowledge(String id) async {
    try {
      final response = await KnowledgeApi.deleteKnowledge(id);
      return response;
    } catch (e) {
      debugPrint("GetConversations Error: $e");
      rethrow;
    }
  }

    Future<UnitsOfKnowledgeListResponse> getUnitsOfKnowledge(
  String id,BaseQueryParams params) async {
    try {
      final response = await KnowledgeApi.getUnitsOfKnowledge(        id, params);
      return response;
    } catch (e) {
      debugPrint("GetConversations Error: $e");
      rethrow;
    }
  }
}
