import 'dart:convert';

import 'package:advancedmobile_chatai/core/util/exception.dart';
import 'package:advancedmobile_chatai/data_app/repository/auth/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

Future<http.Response> retryWithRefreshToken({
  required Uri url,
  required Map<String, String> headers,
  required dynamic body,
}) async {
  print("🔄 Token expired. Refreshing...");
  final newToken = await AuthRepository().fetchRefreshToken();

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
      body:body,
    );
debugPrint("Retry response: ${retryResponse.body}");
    return retryResponse;
  } else {
    throw UnauthorizedException("Token expired and refresh failed");
  }
}
