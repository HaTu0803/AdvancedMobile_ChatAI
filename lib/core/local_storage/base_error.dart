import 'dart:convert';

import 'package:advancedmobile_chatai/core/view_components/dialog_helper.dart';
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
        headers: headers,
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
      // Show success message if provided
      if (responseData['message'] != null) {
        DialogHelper.showSuccess(responseData['message']);
      }
      return responseData;
    } else {
      // Show error message
      final error = responseData['error'] ?? 'Có lỗi xảy ra';

      /// `DialogHelper.showError(error);` is a method call that is used to display an error message to
      /// the user. It is likely a custom method defined in the codebase that shows an error dialog or
      /// message to the user interface. The `error` parameter passed to this method is the error
      /// message that will be displayed to the user.
      DialogHelper.showError(error);
      throw Exception(error);
    }
  }
}
