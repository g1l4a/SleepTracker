import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sleep_tracker/sleep_session.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class SleepSessionNotifier extends StateNotifier<SleepSession> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  SleepSessionNotifier(this.flutterLocalNotificationsPlugin) : super(SleepSession());

  Future<void> startSession() async {
    if (state.startTime == null || state.endTime == null) {
      print('Please set both start and end times.');
      return;
    }

    // Call the start method which includes scheduling the alarm
    await state.start(flutterLocalNotificationsPlugin);

    // Update the state to indicate the session has started
    state = state.copyWith(isSessionActive: true);
    print('Sleep session started.');
  }

  void setStartTime(TimeOfDay time) {
    state = state.copyWith(startTime: time);
  }

  void setEndTime(TimeOfDay time) {
    state = state.copyWith(endTime: time);
  }

  void toggleVibration(bool isEnabled) {
    state = state.copyWith(vibrationEnabled: isEnabled);
  }

  void toggleSound(bool isEnabled) {
    state = state.copyWith(soundEnabled: isEnabled);
  }
}


// Riverpod provider for the SleepSessionNotifier
final sleepSessionProvider = StateNotifierProvider<SleepSessionNotifier, SleepSession>((ref) {
  return SleepSessionNotifier(flutterLocalNotificationsPlugin);
});
