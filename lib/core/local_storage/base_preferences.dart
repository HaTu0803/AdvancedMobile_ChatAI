import 'package:shared_preferences/shared_preferences.dart';

class BasePreferences {
  static final BasePreferences _instance = BasePreferences._internal();
  factory BasePreferences() => _instance;

  static SharedPreferences? _prefs;
  static const String _storageKey = 'TokenLogin_';

  BasePreferences._internal();

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<bool> setTokenPreferred(String key, String token) async {
    if (_prefs == null) await init();
    return _prefs!.setString('$_storageKey$key', token);
  }

  Future<String> getTokenPreferred(String key) async {
    if (_prefs == null) await init();
    return _prefs!.getString('$_storageKey$key') ?? '';
  }

  Future<bool> removeTokenPreferred(String key) async {
    if (_prefs == null) await init();
    return _prefs!.remove('$_storageKey$key');
  }

  Future<void> clearTokens() async {
    await removeTokenPreferred('access_token');
    await removeTokenPreferred('refresh_token');
  }
}
