import 'package:shared_preferences/shared_preferences.dart';

class SessionSummarySharedPreferences {
  static const String _durationKey = 'sessionDuration';
  static const String _sleepRatingKey = 'sleepRating';

  static Future<void> saveSessionSummary(Duration duration, int sleepRating) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_durationKey, duration.inMinutes);
    await prefs.setInt(_sleepRatingKey, sleepRating);
  }

  static Future<Map<String, dynamic>> loadSessionSummary() async {
    final prefs = await SharedPreferences.getInstance();
    final durationMinutes = prefs.getInt(_durationKey) ?? 0;
    final sleepRating = prefs.getInt(_sleepRatingKey) ?? 0;

    return {
      'duration': Duration(minutes: durationMinutes),
      'sleepRating': sleepRating,
    };
  }

  static Future<void> clearSessionSummary() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_durationKey);
    await prefs.remove(_sleepRatingKey);
  }
}
