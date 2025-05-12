import 'dart:core';
import 'dart:io';

import 'package:advancedmobile_chatai/data_app/model/base/base_model.dart';
import 'package:advancedmobile_chatai/data_app/model/knowledge_base/knowledge_data_source_model_v2.dart';
import 'package:advancedmobile_chatai/data_app/remote/knowledge_base/knowledge_data_source_remote_v2.dart';
import 'package:flutter/material.dart';


class KnowledgeDataRepository {
  final KnowledgeDataApiClient KnowledgeDataApi = KnowledgeDataApiClient();



  Future<ConfluenceResponse> uploadConfluence(
      String id, DataSourcesModel request) async {
    try {
      final response = await KnowledgeDataApi.uploadConfluence(id, request);
      return response;
    } catch (e) {
      debugPrint("ConfluenceResponse Error: $e");
      rethrow;
    }
  }


   Future<DataSourceResponse> getDataSources(String id, BaseQueryParams params) async {
    try {
      final response = await KnowledgeDataApi.getDataSources(id, params);
      return response;
    } catch (e) {
      debugPrint("getDataSources Error: $e");
      rethrow;
    }
  }
   Future<FileModelResponse> uploadFile(File file) async {
    try {
      final response = await KnowledgeDataApi.uploadFile(file);
      return response;
    } catch (e) {
      debugPrint("getDataSources Error: $e");
      rethrow;
    }
  }
  Future<DataSourceFileResponse> importDataSource(String id, DataSourceRequest request) async {
    try {
      final response = await KnowledgeDataApi.importDataSource(id, request);
      return response;
    } catch (e) {
      debugPrint("importDataSource Error: $e");
      rethrow;
    }
  }
    Future<KnowledgeDataSource> updateDataSource(
      String id, String dataSourceId, bool status) async {
    try {
      final response = await KnowledgeDataApi.updateDataSource(id, dataSourceId, status);
      return response;
    } catch (e) {
      debugPrint("updateDataSource Error: $e");
      rethrow;
    }
  }
   Future<bool> deleteDataSource(
      String id, String dataSourceId) async {
    try {
      final response = await KnowledgeDataApi.deleteDataSource(id, dataSourceId);
      return response;
    } catch (e) {
      debugPrint("updateDataSource Error: $e");
      rethrow;
    }
  }
}
