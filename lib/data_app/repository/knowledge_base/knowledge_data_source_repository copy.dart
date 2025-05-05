import 'dart:core';
import 'dart:io';

import 'package:advancedmobile_chatai/data_app/model/knowledge_base/knowledge_data_source_model.dart';
import 'package:advancedmobile_chatai/data_app/remote/knowledge_base/knowledge_data_source_remote.dart';
import 'package:flutter/material.dart';

class KnowledgeDataRepository {
  final KnowledgeDataApiClient KnowledgeDataApi = KnowledgeDataApiClient();

  Future<UploadFileResponse> uploadLocalFile(String id, File file) async {
    try {
      final response = await KnowledgeDataApi.uploadLocalFile(id, file);
      return response;
    } catch (e) {
      debugPrint("GetConversations Error: $e");
      rethrow;
    }
  }

  Future<UploadFileResponse> uploadGgDrive(String id) async {
    try {
      final response = await KnowledgeDataApi.uploadGgDrive(id);
      return response;
    } catch (e) {
      debugPrint("GetConversations Error: $e");
      rethrow;
    }
  }

  Future<UploadFileResponse> uploadSlack(String id, UpLoadFileSlack request) async {
    try {
      final response = await KnowledgeDataApi.uploadSlack(id, request);
      return response;
    } catch (e) {
      debugPrint("GetConversations Error: $e");
      rethrow;
    }
  }

  Future<UploadFileResponse> uploadConfluence(
      String id, UploadFileConfluence request) async {
    try {
      final response = await KnowledgeDataApi.uploadConfluence(id, request);
      return response;
    } catch (e) {
      debugPrint("GetConversations Error: $e");
      rethrow;
    }
  }

  Future<UploadFileResponse> uploadWeb(String id, UploadWebsite request) async {
    try {
      final response = await KnowledgeDataApi.uploadWeb(id, request);
      return response;
    } catch (e) {
      debugPrint("GetConversations Error: $e");
      rethrow;
    }
  }
}
