import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_tracker/sleep_session.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class SleepSessionNotifier extends StateNotifier<SleepSession> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static const String sessionCountKey = 'sessionCount';

  SleepSessionNotifier(this.flutterLocalNotificationsPlugin)
      : super(SleepSession()) {
    loadFromPreferences();
  }

  Future<void> startSession() async {
    if (state.startTime == null || state.endTime == null) {
      print('Please set both start and end times.');
      return;
    }
    state.stopTimer();
    state.startTimer(() {
      state = state.copyWith();
    });

    state = state.copyWith(isSessionActive: true);
    await _saveToPreferences();
    print('Sleep session started.');
  }

  Future<void> cancelSession() async {
    state.stopTimer();
    state = state.copyWith(isSessionActive: false);
    await _saveToPreferences();
    print('Sleep session canceled.');
  }

  void setStartTime(TimeOfDay time) {
    state = state.copyWith(startTime: time);
    _saveToPreferences();
  }

  void setEndTime(TimeOfDay time) {
    state = state.copyWith(endTime: time);
    _saveToPreferences();
  }

  void toggleVibration(bool isEnabled) {
    state = state.copyWith(vibrationEnabled: isEnabled);
    _saveToPreferences();
  }

  void toggleSound(bool isEnabled) {
    state = state.copyWith(soundEnabled: isEnabled);
    _saveToPreferences();
  }

  Duration getRemainingTime() {
    return state.getRemainingTime();
  }

  Future<void> _saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if the session is already saved and active
    if (state.isSessionActive) {
      int sessionCount = prefs.getInt(sessionCountKey) ?? 0;
      String sessionKey = 'session_$sessionCount';

      // Save the session only if it wasn't saved before
      await prefs.setString(sessionKey, serializeSession(state));
      await prefs.setInt(sessionCountKey, sessionCount + 1);
    }
  }

  String serializeSession(SleepSession session) {
    return '{"startTime": {"hour": ${session.startTime!.hour}, "minute": ${session.startTime!.minute}}, '
        '"endTime": {"hour": ${session.endTime!.hour}, "minute": ${session.endTime!.minute}}, '
        '"vibrationEnabled": ${session.vibrationEnabled}, '
        '"soundEnabled": ${session.soundEnabled}, '
        '"isSessionActive": ${session.isSessionActive}}';
  }

  Future<void> loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    int sessionCount = prefs.getInt(sessionCountKey) ?? 0;

    for (int i = 0; i < sessionCount; i++) {
      String sessionKey = 'session_$i';
      int startHour = prefs.getInt('$sessionKey.startHour') ?? 0;
      int startMinute = prefs.getInt('$sessionKey.startMinute') ?? 0;
      int endHour = prefs.getInt('$sessionKey.endHour') ?? 0;
      int endMinute = prefs.getInt('$sessionKey.endMinute') ?? 0;
      bool vibrationEnabled =
          prefs.getBool('$sessionKey.vibrationEnabled') ?? false;
      bool soundEnabled = prefs.getBool('$sessionKey.soundEnabled') ?? true;
      bool isSessionActive =
          prefs.getBool('$sessionKey.isSessionActive') ?? false;

      // Create a new SleepSession and process it as needed
      SleepSession session = SleepSession(
        startTime: TimeOfDay(hour: startHour, minute: startMinute),
        endTime: TimeOfDay(hour: endHour, minute: endMinute),
        vibrationEnabled: vibrationEnabled,
        soundEnabled: soundEnabled,
        isSessionActive: isSessionActive,
      );

      // Here, you would want to store the session data in a list or a similar structure for access
    }

    final startTimeString = prefs.getString('startTime');
    if (startTimeString != null) {
      final timeParts = startTimeString.split(':');
      state = state.copyWith(
          startTime: TimeOfDay(
              hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1])));
    }
    final endTimeString = prefs.getString('endTime');
    if (endTimeString != null) {
      final timeParts = endTimeString.split(':');
      state = state.copyWith(
          endTime: TimeOfDay(
              hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1])));
    }
    state = state.copyWith(
      vibrationEnabled: prefs.getBool('vibrationEnabled') ?? false,
      soundEnabled: prefs.getBool('soundEnabled') ?? true,
      isSessionActive: prefs.getBool('isSessionActive') ?? false,
    );
  }
}

final sleepSessionProvider =
    StateNotifierProvider<SleepSessionNotifier, SleepSession>((ref) {
  return SleepSessionNotifier(flutterLocalNotificationsPlugin);
});
