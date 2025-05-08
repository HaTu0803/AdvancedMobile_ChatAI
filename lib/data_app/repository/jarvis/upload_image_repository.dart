import 'package:advancedmobile_chatai/data_app/model/jarvis/upload_image_model.dart';
import 'package:advancedmobile_chatai/data_app/remote/jarvis/upload_image_remote.dart';
import 'package:flutter/material.dart';

class UploadImageRepository {
  final UploadImageApiClient UploadApi = UploadImageApiClient();
   Future<UploadImageResponse> uploadImage(UploadImage request) async {
    try {
      final response = await UploadApi.uploadImage(request);
      return response;
    } catch (e) {
      debugPrint("UploadImageResponse Error: $e");
      rethrow;
    }
  }
   Future<UploadImageSuccessResponse> uploadImageSuccess(UploadImage request) async {
    try {
      final response = await UploadApi.uploadImageSuccess(request);
      return response;
    } catch (e) {
      debugPrint("UploadImageSuccessResponse Error: $e");
      rethrow;
    }
  }
}