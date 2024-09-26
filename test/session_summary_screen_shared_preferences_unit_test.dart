import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_tracker/session_summary_screen_shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SessionSummarySharedPreferences Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('saveSessionSummary saves data', () async {
      await SessionSummarySharedPreferences.saveSessionSummary(const Duration(hours: 2), 4);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('sessionDuration'), 120);
      expect(prefs.getInt('sleepRating'), 4);
    });

    test('loadSessionSummary loads saved data', () async {
      SharedPreferences.setMockInitialValues({
        'sessionDuration': 90,
        'sleepRating': 3,
      });

      final result = await SessionSummarySharedPreferences.loadSessionSummary();
      expect(result['duration'], const Duration(minutes: 90));
      expect(result['sleepRating'], 3);
    });

    test('clearSessionSummary clears saved data', () async {
      SharedPreferences.setMockInitialValues({
        'sessionDuration': 60,
        'sleepRating': 2,
      });

      await SessionSummarySharedPreferences.clearSessionSummary();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('sessionDuration'), null);
      expect(prefs.getInt('sleepRating'), null);
    });
  });
}
