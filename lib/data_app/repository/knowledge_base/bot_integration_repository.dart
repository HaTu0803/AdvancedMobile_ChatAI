import 'package:advancedmobile_chatai/data_app/model/knowledge_base/bot_integrations_model.dart';
import 'package:advancedmobile_chatai/data_app/remote/knowledge_base/bot_integration_remote.dart';
import 'package:flutter/material.dart';

class BotIntegrationRepository {
  final BotIntegrationApiClient BotIntegrationApi = BotIntegrationApiClient();

  Future<dynamic> getConfigurations(String assistantId) async {
    try {
      final response = await BotIntegrationApi.getConfigurations(assistantId);
      return response;
    } catch (e) {
      debugPrint("GetConfigurations Error: $e");
      rethrow;
    }
  }

  Future<bool> disconnectBotIntegration(DisconnectBotIntegration request) async {
    try {
      final response = await BotIntegrationApi.disconnectBotIntegration(request);
      return response;
    } catch (e) {
      debugPrint("DisconnectBotIntegration Error: $e");
      rethrow;
    }
  }

  Future<bool> verifyTelegramBotConfigure(TelegramBot request) async {
    try {
      final response = await BotIntegrationApi.verifyTelegramBotConfigure(request);
      return response;
    } catch (e) {
      debugPrint("VerifyTelegramBotConfigure Error: $e");
      rethrow;
    }
  }

  Future<bool> publishTelegramBot(String assistantId) async {
    try {
      final response = await BotIntegrationApi.publishTelegramBot(assistantId);
      return response;
    } catch (e) {
      debugPrint("PublishTelegramBot Error: $e");
      rethrow;
    }
  }

  Future<bool> verifySlackBotConfigure(SlackBot request) async {
    try {
      final response = await BotIntegrationApi.verifySlackBotConfigure(request);
      return response;
    } catch (e) {
      debugPrint("VerifySlackBotConfigure Error: $e");
      rethrow;
    }
  }

  Future<bool> publishSlackBot(String assistantId) async {
    try {
      final response = await BotIntegrationApi.publishSlackBot(assistantId);
      return response;
    } catch (e) {
      debugPrint("PublishSlackBot Error: $e");
      rethrow;
    }
  }

  Future<bool> verifyMessengerBotConfigure(MessengerSlackBot request) async {
    try {
      final response = await BotIntegrationApi.verifyMessengerBotConfigure(request);
      return response;
    } catch (e) {
      debugPrint("VerifyMessengerBotConfigure Error: $e");
      rethrow;
    }
  }

  Future<bool> publishMessengerBot(String assistantId) async {
    try {
      final response = await BotIntegrationApi.publishMessengerBot(assistantId);
      return response;
    } catch (e) {
      debugPrint("PublishMessengerBot Error: $e");
      rethrow;
    }
  }
}
