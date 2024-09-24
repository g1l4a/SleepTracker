import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_tracker/sleep_session.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class SleepSessionNotifier extends StateNotifier<SleepSession> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  SleepSessionNotifier(this.flutterLocalNotificationsPlugin) : super(SleepSession()) {
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
    await prefs.setString('startTime', state.startTime != null ? '${state.startTime!.hour}:${state.startTime!.minute}' : '');
    await prefs.setString('endTime', state.endTime != null ? '${state.endTime!.hour}:${state.endTime!.minute}' : '');
    await prefs.setBool('vibrationEnabled', state.vibrationEnabled);
    await prefs.setBool('soundEnabled', state.soundEnabled);
    await prefs.setBool('isSessionActive', state.isSessionActive);
  }

  Future<void> loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final startTimeString = prefs.getString('startTime');
    if (startTimeString != null) {
      final timeParts = startTimeString.split(':');
      state = state.copyWith(startTime: TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1])));
    }
    final endTimeString = prefs.getString('endTime');
    if (endTimeString != null) {
      final timeParts = endTimeString.split(':');
      state = state.copyWith(endTime: TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1])));
    }
    state = state.copyWith(
      vibrationEnabled: prefs.getBool('vibrationEnabled') ?? false,
      soundEnabled: prefs.getBool('soundEnabled') ?? true,
      isSessionActive: prefs.getBool('isSessionActive') ?? false,
    );
  }

}


final sleepSessionProvider = StateNotifierProvider<SleepSessionNotifier, SleepSession>((ref) {
  return SleepSessionNotifier(flutterLocalNotificationsPlugin);
});
