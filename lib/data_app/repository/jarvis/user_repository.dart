import 'package:advancedmobile_chatai/data_app/model/jarvis/user_model.dart';
import 'package:advancedmobile_chatai/data_app/remote/jarvis/user_remote.dart';
import 'package:flutter/material.dart';

class TokenRepository {
  final UserApiClient UserApi = UserApiClient();

  Future<CurrentUserReponse> getCurrentUser() async {
    try {
      final response = await UserApi.getCurrentUser();
      return response;
    } catch (e) {
      debugPrint("Error: $e");
      rethrow;
    }
  }
}
