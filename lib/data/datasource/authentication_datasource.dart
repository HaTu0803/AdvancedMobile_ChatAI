import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../util/auth_manager.dart';
import '../../util/exception.dart';

abstract class IAuthenticationDatasource {
  Future<void> register(
      String email, String password, String confirmPassword, String name);
  Future<String> login(String email, String password);
}

class AuthenticationRemote extends IAuthenticationDatasource {
  final String baseUrl = 'https://your-api-url.com'; // Thay bằng URL API thực tế

  @override
  Future<void> register(
      String email, String password, String confirmPassword, String name) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/collections/users/records'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username': name,
          'password': password,
          'passwordConfirm': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        await login(email, password);
      } else {
        throw ApiException(response.statusCode, jsonDecode(response.body)['message']);
      }
    } catch (ex) {
      throw ApiException(0, 'Unknown error');
    }
  }

  @override
  Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/collections/users/auth-with-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identity': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        AuthManager.saveId(data['record']['id']);
        AuthManager.saveToken(data['token']);
        return data['token'];
      } else {
        throw ApiException(response.statusCode, jsonDecode(response.body)['message']);
      }
    } catch (ex) {
      throw ApiException(0, 'Unknown error');
    }
  }
}
