import 'package:advancedmobile_chatai/data_app/repository/auth/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../providers/auth_provider.dart';

Future<http.Response> retryWithRefreshToken({
  required Uri url,
  required String method, // New method parameter
  Map<String, String>? headers,
  dynamic body,
}) async {
  print("🔄 Token expired. Refreshing...");
  final newToken = await AuthProvider().fetchRefreshToken();
  debugPrint("newToken: $newToken");

  final retryHeaders = {
    // 'Content-Type': 'application/json',
    'Authorization': 'Bearer $newToken',
    ...?headers,
  };

  http.Response retryResponse;

  switch (method.toUpperCase()) {
    case 'GET':
      retryResponse = await http.get(url, headers: retryHeaders);
      break;
    case 'POST':
      retryResponse = await http.post(url, headers: retryHeaders, body: body);
      break;
    case 'PATCH':
      retryResponse = await http.patch(url, headers: retryHeaders, body: body);
      break;
    case 'DELETE':
      retryResponse = await http.delete(url, headers: retryHeaders, body: body);
      break;
    default:
      throw UnsupportedError("Unsupported HTTP method: $method");
  }

  debugPrint("Retry response: ${retryResponse.body}");
  return retryResponse;
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
