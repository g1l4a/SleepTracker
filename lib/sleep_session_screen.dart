import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'sleep_session_provider.dart'; // Assuming the provided notifier and session code is here

class SleepSessionScreen extends ConsumerWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  SleepSessionScreen({required this.flutterLocalNotificationsPlugin});

  Future<TimeOfDay?> _pickTime(BuildContext context, TimeOfDay? initialTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );
    return pickedTime;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sleepSession = ref.watch(sleepSessionProvider);
    final sleepSessionNotifier = ref.read(sleepSessionProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Session'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              sleepSession.startTime != null
                  ? "Start Time: ${sleepSession.getFormattedTime(sleepSession.startTime)}"
                  : "Start Time: Not set",
              style: TextStyle(fontSize: 18),
            ),
            TextButton(
              onPressed: () async {
                final TimeOfDay? pickedTime = await _pickTime(context, sleepSession.startTime);
                if (pickedTime != null) {
                  sleepSessionNotifier.setStartTime(pickedTime);
                }
              },
              child: Text('Set Start Time'),
            ),
            SizedBox(height: 20),
            Text(
              sleepSession.endTime != null
                  ? "End Time: ${sleepSession.getFormattedTime(sleepSession.endTime)}"
                  : "End Time: Not set",
              style: TextStyle(fontSize: 18),
            ),
            TextButton(
              onPressed: () async {
                final TimeOfDay? pickedTime = await _pickTime(context, sleepSession.endTime);
                if (pickedTime != null) {
                  sleepSessionNotifier.setEndTime(pickedTime);
                }
              },
              child: Text('Set End Time'),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text("Vibration"),
              value: sleepSession.vibrationEnabled,
              onChanged: (value) {
                sleepSessionNotifier.toggleVibration(value);
              },
            ),
            SwitchListTile(
              title: Text("Sound"),
              value: sleepSession.soundEnabled,
              onChanged: (value) {
                sleepSessionNotifier.toggleSound(value);
              },
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                if (sleepSession.startTime != null && sleepSession.endTime != null) {
                  await sleepSessionNotifier.startSession();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please set both start and end times.")),
                  );
                }
              },
              child: Text('Start Sleep Session'),
            ),
          ],
        ),
      ),
    );
  }
}
