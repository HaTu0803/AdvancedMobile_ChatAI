import 'package:advancedmobile_chatai/core/util/exception.dart';
import 'package:advancedmobile_chatai/data_app/repository/auth/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../providers/auth_provider.dart';

Future<http.Response> retryWithRefreshToken({
  required Uri url,
  required Map<String, String> headers,
  required dynamic body,
}) async {
  print("🔄 Token expired. Refreshing...");
  final newToken = await AuthProvider().fetchRefreshToken();

  if (newToken != null) {
    final retryHeaders = {
      ...headers,
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $newToken',
    };
    debugPrint("newToken: $newToken");

    final retryResponse = await http.post(
      url,
      headers: retryHeaders,
      body: body,
    );
    debugPrint("Retry response: ${retryResponse.body}");
    return retryResponse;
  } else {
    throw UnauthorizedException("Token expired and refresh failed");
  }
}

Future<http.Response> retryWithRefreshTokenMultipart({
  required Uri url,
  required Map<String, String> headers,
  required String filePath,
}) async {
  final newToken = await AuthRepository().fetchRefreshToken();
  headers['Authorization'] = 'Bearer $newToken';

  var retryRequest = http.MultipartRequest('POST', url);
  retryRequest.headers.addAll(headers);
  retryRequest.files.add(await http.MultipartFile.fromPath('file', filePath));

  final streamedResponse = await retryRequest.send();
  final response = await http.Response.fromStream(streamedResponse);
  return response;
}
