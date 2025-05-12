import 'package:advancedmobile_chatai/data_app/model/jarvis/ai_email_model.dart';
import 'package:advancedmobile_chatai/data_app/remote/jarvis/ai_email_remote.dart';
import 'package:flutter/material.dart';

class EmailRepository {
  final AiEmailApiClient AiEmailApi = AiEmailApiClient();

  Future<EmailResponse> responseEmail(EmailRequestModel request) async {
    try {
      final response = await AiEmailApi.responseEmail(request);
      return response;
    } catch (e) {
      debugPrint("Error: $e");
      rethrow;
    }
  }

  Future<IdeaResponse> suggestReplyIdeas(SuggestReplyIdeas request) async {
    try {
      final response = await AiEmailApi.suggestReplyIdeas(request);
      return response;
    } catch (e) {
      debugPrint("Error: $e");
      rethrow;
    }
  }
}
