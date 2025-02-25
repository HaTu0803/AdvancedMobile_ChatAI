import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiException implements Exception {
  int? code;
  String? message;
  Map<String, dynamic>? responseData;

  ApiException(this.code, this.message, {http.Response? response}) {
    if (code != 400) {
      return;
    }
    if (message == 'Failed to authenticate.') {
      message = 'Password or username is incorrect';
    }
    if (message == 'Failed to create record.' && response != null) {
      try {
        responseData = jsonDecode(response.body);

        if (responseData?['data']?['username']?['message'] ==
            'The username is invalid or already in use.') {
          message = 'Username is already in use';
        }

        if (responseData?['data']?['email']?['message'] ==
            'The email is invalid or already in use.') {
          message = 'Email is already in use';
        }
      } catch (e) {
        // Lỗi khi parse JSON, giữ nguyên message mặc định
      }
    }
  }
}
