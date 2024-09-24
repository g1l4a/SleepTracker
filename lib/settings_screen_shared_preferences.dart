import 'package:shared_preferences/shared_preferences.dart';

class SettingsSharedPreferences {
  static Future<void> saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  static Future<dynamic> loadSetting(String key, dynamic defaultValue) async {
    final prefs = await SharedPreferences.getInstance();
    if (defaultValue is bool) {
      return prefs.getBool(key) ?? defaultValue;
    } else if (defaultValue is String) {
      return prefs.getString(key) ?? defaultValue;
    }
  }
}
