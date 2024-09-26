import 'dart:async';
import 'dart:typed_data';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SleepSession {
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool vibrationEnabled;
  bool soundEnabled;
  bool isSessionActive;
  Timer? timer;

  SleepSession({
    this.startTime,
    this.endTime,
    this.vibrationEnabled = false,
    this.soundEnabled = true,
    this.isSessionActive = false,
    this.timer
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
      timer: timer
    );
  }

  Future<void> start(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    if (startTime == null || endTime == null) {
      print("Start or End time is not set.");
      return;
    }

    final startTimeInMinutes = startTime!.hour * 60 + startTime!.minute;
    final endTimeInMinutes = endTime!.hour * 60 + endTime!.minute;
    isSessionActive = true;

    if (endTimeInMinutes <= startTimeInMinutes) {
      print("End time must be after the start time.");
      return;
    }

    //await _scheduleAlarm(flutterLocalNotificationsPlugin); remove // when test on android
    await _saveToPreferences();
  }

  // Future<void> _scheduleAlarm(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  //   final endTimeDateTime = DateTime.now().add(Duration(
  //     hours: endTime!.hour - TimeOfDay.now().hour,
  //     minutes: endTime!.minute - TimeOfDay.now().minute,
  //   ));

  //   var androidDetails = AndroidNotificationDetails(
  //     'sleep_session_channel',
  //     'Sleep Session Channel',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //     vibrationPattern: vibrationEnabled ? Int64List.fromList([0, 1000, 500, 1000]) : null,
  //     sound: soundEnabled ? const RawResourceAndroidNotificationSound('alarm') : null,
  //   );
    
  //   var platformDetails = NotificationDetails(android: androidDetails);
    
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     0,
  //     'Wake up!',
  //     'Your sleep session has ended.',
  //     tz.TZDateTime.from(endTimeDateTime, tz.local),
  //     platformDetails,
  //     androidAllowWhileIdle: true,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //     matchDateTimeComponents: DateTimeComponents.time,
  //   );

  //   print("Alarm scheduled for ${getFormattedTime(endTime)}.");
  // }

  String getFormattedTime(TimeOfDay? time) {
    if (time == null) return '--:--';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  Duration getRemainingTime() {
    final now = TimeOfDay.now();
    
    int nowInMinutes = now.hour * 60 + now.minute;
    int startInMinutes = (startTime?.hour ?? now.hour) * 60 + (startTime?.minute ?? now.minute);
    int endInMinutes = (endTime?.hour ?? now.hour) * 60 + (endTime?.minute ?? now.minute);
    
    if (endInMinutes <= startInMinutes) {
      endInMinutes += 24 * 60; 
    }

    if (nowInMinutes >= startInMinutes && nowInMinutes < endInMinutes) {
      return Duration(minutes: endInMinutes - nowInMinutes);
    }
    
    return Duration.zero; 
  }

  Duration getFullTime() {
    final now = TimeOfDay.now();
    int startInMinutes = (startTime?.hour ?? now.hour) * 60 + (startTime?.minute ?? now.minute);
    int endInMinutes = (endTime?.hour ?? now.hour) * 60 + (endTime?.minute ?? now.minute);
    
    return Duration(minutes: endInMinutes - startInMinutes);
  }


  void startTimer(Function onUpdate) {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      onUpdate();
    });
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }
  
  Future<void> _saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('startTime', startTime != null ? '${startTime!.hour}:${startTime!.minute}' : '');
    await prefs.setString('endTime', endTime != null ? '${endTime!.hour}:${endTime!.minute}' : '');
    await prefs.setBool('vibrationEnabled', vibrationEnabled);
    await prefs.setBool('soundEnabled', soundEnabled);
    await prefs.setBool('isSessionActive', isSessionActive);
  }


  Future<void> loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final startTimeString = prefs.getString('startTime');
    if (startTimeString != null) {
      final timeParts = startTimeString.split(':');
      startTime = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
    }
    final endTimeString = prefs.getString('endTime');
    if (endTimeString != null) {
      final timeParts = endTimeString.split(':');
      endTime = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
    }
    vibrationEnabled = prefs.getBool('vibrationEnabled') ?? false;
    soundEnabled = prefs.getBool('soundEnabled') ?? true;
    isSessionActive = prefs.getBool('isSessionActive') ?? false;
  }
}
