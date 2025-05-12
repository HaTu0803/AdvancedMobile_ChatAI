import 'package:advancedmobile_chatai/data_app/model/jarvis/user_model.dart';
import 'package:advancedmobile_chatai/data_app/remote/jarvis/user_remote.dart';
import 'package:flutter/material.dart';

class TokenRepository {
  final UserApiClient userApi = UserApiClient();

  Future<CurrentUserReponse> getCurrentUser() async {
    try {
      debugPrint("🔄 TokenRepository: Getting current user...");
      final response = await userApi.getCurrentUser();
      debugPrint("✅ TokenRepository: Successfully got user data: ${response.toJson()}");
      return response;
    } catch (e, stackTrace) {
      debugPrint("❌ TokenRepository Error: $e");
      debugPrint("📍 TokenRepository Stack trace: $stackTrace");
      rethrow;
    }
  }
}