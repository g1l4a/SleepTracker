import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleep_tracker/sleep_session_provider.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SleepSessionNotifier tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({}); 
    });

    test('Cancel session should deactivate the session', () async {
      final sleepSessionNotifier = SleepSessionNotifier(flutterLocalNotificationsPlugin);

      await sleepSessionNotifier.startSession();

      sleepSessionNotifier.cancelSession();

      expect(sleepSessionNotifier.state.isSessionActive, false);
    });
  });
}
