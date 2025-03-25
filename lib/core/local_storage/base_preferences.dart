import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
const String _storageKey = 'TokenLogin_';

BasePreferences basePreferences = BasePreferences();

class BasePreferences {
  Future<bool> setTokenPreferred(String key, String token) async {
    final prefs = await _prefs;
    return prefs.setString(_storageKey + key, token);
  }

  Future<String> getTokenPreferred(String key) async {
    final prefs = await _prefs;
    return prefs.getString(_storageKey + key) ?? '';
  }
}
