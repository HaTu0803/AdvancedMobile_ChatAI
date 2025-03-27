import 'package:advancedmobile_chatai/core/local_storage/base_preferences.dart';
import 'package:advancedmobile_chatai/data_app/model/auth/auth_model.dart';
import 'package:advancedmobile_chatai/data_app/remote/auth/auth_api_client.dart';

class AuthRepository {
  final authApiClient = AuthApiClient();
  final BasePreferences basePreferences = BasePreferences();

  Future<AuthResponse> signUp(SignUpRequest request) async {
    return await authApiClient.signUp(request);
  }

  Future<AuthResponse> signIn(SignInRequest request) async {
    return await authApiClient.signIn(request);
  }

  Future<void> logOut(String token, String refreshToken) async {
    return await authApiClient.logOut(token, refreshToken);
  }
}
