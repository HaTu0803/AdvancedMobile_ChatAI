import 'dart:convert';

import 'package:advancedmobile_chatai/core/helpers/dialog_helper.dart';
import 'package:http/http.dart' as http;

class BaseError {
  final http.Client _client;

  BaseError(this._client);

  Future<Map<String, dynamic>> post(
    String url, {
    required Map<String, dynamic> body,
    required Map<String, String> headers,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(url),
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      DialogHelper.showError('Lỗi kết nối: $e');
      throw Exception(e);
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return responseData;
    } else {
      final error = responseData['error'] ?? 'Có lỗi xảy ra';
      DialogHelper.showError(error);
      throw Exception(error);
    }
  }
}
