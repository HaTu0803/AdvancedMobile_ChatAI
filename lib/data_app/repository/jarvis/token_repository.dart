import 'package:advancedmobile_chatai/data_app/model/jarvis/token_model.dart';
import 'package:advancedmobile_chatai/data_app/remote/jarvis/token_remote.dart';
import 'package:flutter/material.dart';

class TokenRepository {
  final TokenApiClient TokenApi = TokenApiClient();

  Future<UsageTokenResponse> getUsage() async {
    try {
      final response = await TokenApi.getUsage();
      return response;
    } catch (e) {
      debugPrint("Error: $e");
      rethrow;
    }
  }
}
