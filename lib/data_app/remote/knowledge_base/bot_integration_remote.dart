import 'dart:convert';
import 'package:advancedmobile_chatai/core/config/api_headers.dart';
import 'package:advancedmobile_chatai/core/helpers/dialog_helper.dart';
import 'package:advancedmobile_chatai/core/helpers/refresh_token_helper.dart';
import 'package:advancedmobile_chatai/core/local_storage/base_preferences.dart';
import 'package:advancedmobile_chatai/data_app/model/knowledge_base/bot_integrations_model.dart';
import 'package:advancedmobile_chatai/data_app/url_api/knowledge_base/bot_integration_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../../core/navigation/routes.dart';
import '../../repository/auth/authentication_repository.dart';

class BotIntegrationApiClient {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> getConfigurations(String assistantId) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    final url = Uri.parse(ApiBotIntegrationUrl.getConfigurations(assistantId));
    final headers = ApiHeaders.getAIChatHeaders("", token);
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        method: 'GET',
      );
      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return jsonDecode(retryResponse.body);
      } else {
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Session expired. Please log in again.');
      }
    } else {
      handleErrorResponse(response);
      throw Exception('Failed to get configurations.');
    }
  }

  Future<bool> disconnectBotIntegration(DisconnectBotIntegration request) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    final url = Uri.parse(ApiBotIntegrationUrl.disconnectBotIntegration(request.assistantId, request.type));
    final headers = ApiHeaders.getAIChatHeaders("", token);
    final response = await http.delete(url, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        method: 'DELETE',
      );
      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201 || retryResponse.statusCode == 204) {
        return true;
      } else {
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Session expired. Please log in again.');
      }
    } else {
      handleErrorResponse(response);
      throw Exception('Failed to disconnect bot integration.');
    }
  }

  Future<bool> verifyTelegramBotConfigure(TelegramBot request) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    final url = Uri.parse(ApiBotIntegrationUrl.verifyTelegramBotConfigure);
    final headers = ApiHeaders.getAIChatHeaders("", token);
    final body = jsonEncode(request.toJson());
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        body: body,
        method: 'POST',
      );
      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return true;
      } else {
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Session expired. Please log in again.');
      }
    } else {
      handleErrorResponse(response);
      throw Exception('Failed to verify Telegram bot configuration.');
    }
  }

  Future<bool> publishTelegramBot(String assistantId) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    final url = Uri.parse(ApiBotIntegrationUrl.publishTelegramBot(assistantId));
    final headers = ApiHeaders.getAIChatHeaders("", token);
    final response = await http.post(url, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        method: 'POST',
      );
      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return true;
      } else {
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Session expired. Please log in again.');
      }
    } else {
      handleErrorResponse(response);
      throw Exception('Failed to publish Telegram bot.');
    }
  }

  Future<bool> verifySlackBotConfigure(SlackBot request) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    final url = Uri.parse(ApiBotIntegrationUrl.verifySlackBotConfigure);
    final headers = ApiHeaders.getAIChatHeaders("", token);
    final body = jsonEncode(request.toJson());
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        body: body,
        method: 'POST',
      );
      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return true;
      } else {
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Session expired. Please log in again.');
      }
    } else {
      handleErrorResponse(response);
      throw Exception('Failed to verify Slack bot configuration.');
    }
  }

  Future<bool> publishSlackBot(String assistantId) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    final url = Uri.parse(ApiBotIntegrationUrl.publishSlackBot(assistantId));
    final headers = ApiHeaders.getAIChatHeaders("", token);
    final response = await http.post(url, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        method: 'POST',
      );
      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return true;
      } else {
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Session expired. Please log in again.');
      }
    } else {
      handleErrorResponse(response);
      throw Exception('Failed to publish Slack bot.');
    }
  }

  Future<bool> verifyMessengerBotConfigure(MessengerSlackBot request) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    final url = Uri.parse(ApiBotIntegrationUrl.verifyMessengerBotConfigure);
    final headers = ApiHeaders.getAIChatHeaders("", token);
    final body = jsonEncode(request.toJson());
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        body: body,
        method: 'POST',
      );
      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return true;
      } else {
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Session expired. Please log in again.');
      }
    } else {
      handleErrorResponse(response);
      throw Exception('Failed to verify Messenger bot configuration.');
    }
  }

  Future<bool> publishMessengerBot(String assistantId) async {
    await BasePreferences.init();
    String token = await BasePreferences().getTokenPreferred('access_token');
    final url = Uri.parse(ApiBotIntegrationUrl.publishMessengerBot(assistantId));
    final headers = ApiHeaders.getAIChatHeaders("", token);
    final response = await http.post(url, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      final retryResponse = await retryWithRefreshToken(
        url: url,
        method: 'POST',
      );
      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return true;
      } else {
        await AuthRepository().logOut();
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => true,
        );
        throw Exception('Session expired. Please log in again.');
      }
    } else {
      handleErrorResponse(response);
      throw Exception('Failed to publish Messenger bot.');
    }
  }
}
