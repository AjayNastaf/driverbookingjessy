import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static Future<void> setDone(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, true);
  }

  static Future<bool> isDone(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }
}
