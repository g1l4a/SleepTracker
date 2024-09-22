import 'dart:typed_data';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class SleepSession {
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool vibrationEnabled;
  bool soundEnabled;
  bool isSessionActive;

  SleepSession({
    this.startTime,
    this.endTime,
    this.vibrationEnabled = false,
    this.soundEnabled = true,
    this.isSessionActive = false,
  });

   SleepSession copyWith({
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    bool? vibrationEnabled,
    bool? soundEnabled,
    bool? isSessionActive,
  }) {
    return SleepSession(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      isSessionActive: isSessionActive ?? this.isSessionActive,
    );
  }

  Future<void> start(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    if (startTime == null || endTime == null) {
      print("Start or End time is not set.");
      return;
    }

    final startTimeInMinutes = startTime!.hour * 60 + startTime!.minute;
    final endTimeInMinutes = endTime!.hour * 60 + endTime!.minute;

    if (endTimeInMinutes <= startTimeInMinutes) {
      print("End time must be after the start time.");
      return;
    }

    await _scheduleAlarm(flutterLocalNotificationsPlugin);
  }

  Future<void> _scheduleAlarm(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    final endTimeDateTime = DateTime.now().add(Duration(
      hours: endTime!.hour - TimeOfDay.now().hour,
      minutes: endTime!.minute - TimeOfDay.now().minute,
    ));

    var androidDetails = AndroidNotificationDetails(
      'sleep_session_channel',
      'Sleep Session Channel',
      importance: Importance.high,
      priority: Priority.high,
      vibrationPattern: vibrationEnabled ? Int64List.fromList([0, 1000, 500, 1000]) : null,
      sound: soundEnabled ? RawResourceAndroidNotificationSound('alarm') : null,
    );
    
    var platformDetails = NotificationDetails(android: androidDetails);
    
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Wake up!',
      'Your sleep session has ended.',
      tz.TZDateTime.from(endTimeDateTime, tz.local),
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    print("Alarm scheduled for ${getFormattedTime(endTime)}.");
  }

  String getFormattedTime(TimeOfDay? time) {
    if (time == null) return '--:--';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  // New method to calculate remaining time in minutes
  Duration getRemainingTime() {
    if (startTime == null || endTime == null) {
      return Duration.zero;
    }

    final now = TimeOfDay.now();
    final nowInMinutes = now.hour * 60 + now.minute;
    final endInMinutes = endTime!.hour * 60 + endTime!.minute;

    // If the current time is past the end time, return zero
    if (nowInMinutes >= endInMinutes) {
      return Duration.zero;
    }

    return Duration(minutes: endInMinutes - nowInMinutes);
  }
}
