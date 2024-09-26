import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_tracker/sleep_session_provider.dart';

void main() {

  TestWidgetsFlutterBinding.ensureInitialized();

  late SleepSessionNotifier sleepSessionNotifier;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'startTime': '22:00',
      'endTime': '06:00',
      'vibrationEnabled': false,
      'soundEnabled': true,
      'isSessionActive': false,
    });

    sleepSessionNotifier = SleepSessionNotifier(flutterLocalNotificationsPlugin);
    await sleepSessionNotifier.loadFromPreferences();
  });

  test('Setting start time should update state', () async {
    sleepSessionNotifier.setStartTime(const TimeOfDay(hour: 22, minute: 30));
    expect(sleepSessionNotifier.state.startTime, const TimeOfDay(hour: 22, minute: 30));
  });

  test('Cancel session should deactivate the session', () async {
    await sleepSessionNotifier.cancelSession();
    expect(sleepSessionNotifier.state.isSessionActive, false);
  });

  test('Toggling vibration should change vibration setting', () async {
    sleepSessionNotifier.toggleVibration(true);
    expect(sleepSessionNotifier.state.vibrationEnabled, true);
  });
}
