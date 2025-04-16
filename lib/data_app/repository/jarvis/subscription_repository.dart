import 'package:advancedmobile_chatai/data_app/model/jarvis/subscription_model.dart';
import 'package:advancedmobile_chatai/data_app/remote/jarvis/subscription_remote.dart';
import 'package:flutter/material.dart';

class SubscriptionRepository {
  final SubscriptionApiClient SubscriptionApi = SubscriptionApiClient();

  Future<UsageResponse> getUsage() async {
    try {
      final response = await SubscriptionApi.getUsage();
      return response;
    } catch (e) {
      debugPrint("Error: $e");
      rethrow;
    }
  }

  Future<bool> subscribe() async {
    try {
      final response = await SubscriptionApi.subscribe();
      return response;
    } catch (e) {
      debugPrint("Error: $e");
      rethrow;
    }
  }
}
