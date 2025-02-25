import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpProvider {
  static const String baseUrl =
      'https://pocketbase--bmabfep1.iran.liara.run/api/';

  static Future<http.Response> post(
      String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response;
  }

  static Future<http.Response> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }
}
