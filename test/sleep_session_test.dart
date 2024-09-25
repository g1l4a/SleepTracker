import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleep_tracker/sleep_session.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() {
  group('SleepSession', () {
    test('should initialize with correct default values', () {
      final session = SleepSession();

      expect(session.isSessionActive, false);
      expect(session.startTime, null);
      expect(session.endTime, null);
    });
  });
}
