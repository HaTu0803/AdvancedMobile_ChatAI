import 'package:advancedmobile_chatai/data_app/model/auth/auth_model.dart';
import 'package:advancedmobile_chatai/data_app/remote/auth/auth_api_client.dart';

class AuthRepository {
  final authApiClient = AuthApiClient();

  Future<AuthResponse> signUp(SignUpRequest request) async {
    return await authApiClient.fetchSignUp(request);
  }

  Future<AuthResponse> signIn(SignInRequest request) async {
    return await authApiClient.fetchSignIn(request);
  }

  Future<void> logOut(String token, String refreshToken) async {
    return await authApiClient.fetchLogOut(token, refreshToken);
  }
}
