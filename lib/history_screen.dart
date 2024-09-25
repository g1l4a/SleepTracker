import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_tracker/achievements_screen.dart';
import 'package:sleep_tracker/home_screen.dart';
import 'package:sleep_tracker/settings_screen.dart';
import 'package:sleep_tracker/sleep_session_provider.dart';
import 'package:sleep_tracker/sleep_session.dart';
import 'nothern_lights.dart';
import 'package:shared_preferences/shared_preferences.dart';

// upload and download session history from sleep_session using shared_prefernces methods
// add nothern_lights as background
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_tracker/sleep_session_provider.dart';
import 'package:sleep_tracker/sleep_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'nothern_lights.dart';
import 'dart:convert'; // Import for JSON serialization

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  List<SleepSession> sessionHistory = []; // Store session history
  Map<String, int> commonSettings = {}; // For tracking common settings

  @override
  void initState() {
    super.initState();
    loadSessionHistory();
  }

  Future<void> loadSessionHistory() async {
    final prefs = await SharedPreferences.getInstance();
    int sessionCount = prefs.getInt('sessionCount') ?? 0;

    for (int i = 0; i < sessionCount; i++) {
      String? sessionData = prefs.getString('session_$i');
      if (sessionData != null) {
        SleepSession session = deserializeSession(sessionData);
        sessionHistory.add(session);
        updateCommonSettings(session);
      }
    }
    setState(() {});
  }

  SleepSession deserializeSession(String sessionData) {
    // Deserialize JSON string back to SleepSession object
    Map<String, dynamic> json = jsonDecode(sessionData);
    return SleepSession(
      startTime: TimeOfDay(
        hour: json['startTime']['hour'],
        minute: json['startTime']['minute'],
      ),
      endTime: TimeOfDay(
        hour: json['endTime']['hour'],
        minute: json['endTime']['minute'],
      ),
      vibrationEnabled: json['vibrationEnabled'],
      soundEnabled: json['soundEnabled'],
      isSessionActive: json['isSessionActive'],
      // Add other properties as necessary
    );
  }

  void updateCommonSettings(SleepSession session) {
    commonSettings['vibrationEnabled'] =
        (commonSettings['vibrationEnabled'] ?? 0) +
            (session.vibrationEnabled ? 1 : 0);
    commonSettings['soundEnabled'] =
        (commonSettings['soundEnabled'] ?? 0) + (session.soundEnabled ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 0, 6, 88),
          ),
          const Center(
            child: NorthernLights(
              beginDirection: Alignment.topLeft,
              endDirection: Alignment.bottomRight,
            ),
          ),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildCommonSettingsWidget(),
                const SizedBox(height: 20),
                Expanded(child: _buildSessionHistoryWidget()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommonSettingsWidget() {
    String commonVibration = commonSettings['vibrationEnabled'] != null &&
            commonSettings['vibrationEnabled']! > (sessionHistory.length / 2)
        ? 'Enabled'
        : 'Disabled';
    String commonSound = commonSettings['soundEnabled'] != null &&
            commonSettings['soundEnabled']! > (sessionHistory.length / 2)
        ? 'Enabled'
        : 'Disabled';

    return Card(
      color: Colors.white.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Most Common Settings",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Vibration: $commonVibration"),
            Text("Sound: $commonSound"),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionHistoryWidget() {
    return ListView.builder(
      itemCount: sessionHistory.length,
      itemBuilder: (context, index) {
        SleepSession session = sessionHistory[index];
        return Card(
          color: Colors.white.withOpacity(0.8),
          child: ListTile(
            title: Text("Session ${index + 1}"),
            subtitle: Text(
              "Start: ${session.startTime!.hour}:${session.startTime!.minute}\n"
              "End: ${session.endTime!.hour}:${session.endTime!.minute}\n"
              "Vibration: ${session.vibrationEnabled ? 'Enabled' : 'Disabled'}\n"
              "Sound: ${session.soundEnabled ? 'Enabled' : 'Disabled'}",
            ),
          ),
        );
      },
    );
  }
}
