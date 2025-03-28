import 'package:advancedmobile_chatai/data_app/model/auth/auth_model.dart';
import 'package:advancedmobile_chatai/data_app/repository/authentication_repository.dart';
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
      print("email: $email");
      print("password: $password");
      await authRepository.signIn(SignInRequest(
        email: email,
        password: password,
      ));
      return true;
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
}
