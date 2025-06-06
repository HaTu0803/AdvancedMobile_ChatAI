import 'package:advancedmobile_chatai/core/util/exception.dart';
import 'package:advancedmobile_chatai/data_app/model/auth/auth_model.dart';
import 'package:advancedmobile_chatai/data_app/repository/auth/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository authRepository = AuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _hasSeenIntro = false; // Giá trị mặc định
  bool get hasSeenIntro => _hasSeenIntro;

  Future<void> loadHasSeenIntro() async {
    final prefs = await SharedPreferences.getInstance();
    _hasSeenIntro = prefs.getBool('seenIntroduction') ?? false;
    notifyListeners(); // Thông báo UI cập nhật
  }

  Future<void> setHasSeenIntro(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenIntroduction', value);
    _hasSeenIntro = value;
    notifyListeners();
  }

  Future<bool> signUp(String email, String password) async {
    setLoading(true);
    try {
      debugPrint("🔍 Sending SignUp Request: email=$email, password=$password");
      await authRepository.signUp(SignUpRequest(
        email: email,
        password: password,
      ));
      return true;
    } catch (e) {
      debugPrint("SignUp Error: $e");
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> signIn(String email, String password) async {
    setLoading(true);
    try {
      debugPrint("🔍 Sending SignIn Request: email=$email, password=$password");
      await authRepository.signIn(SignInRequest(
        email: email,
        password: password,
      ));
      return true;
    } on UnauthorizedException catch (e) {
      debugPrint("🔒 Unauthorized: ${e.message}");
      return false;
    } catch (e) {
      debugPrint("SignIn Error: $e");
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> logOut() async {
    setLoading(true);
    try {
      debugPrint("🔍 Sending LogOut Request: ");
      await authRepository.logOut();

      return true;
    } catch (e) {
      debugPrint("LogOut Error: $e");
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> isAuthenticated() async {
    return await authRepository.isAuthenticated();
  }

  Future<String> fetchRefreshToken() async {
    // return await authRepository.fetchRefreshToken();
    setLoading(true);
    try {
      final refreshToken = await authRepository.fetchRefreshToken();
      return refreshToken;
    } catch (e) {
      debugPrint("Fetch Refresh Token Error: $e");
      return '';
    }
    finally {
      setLoading(false);
    }
  }
}
