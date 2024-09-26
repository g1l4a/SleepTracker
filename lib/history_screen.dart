import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_tracker/achievements_screen.dart';
import 'package:sleep_tracker/home_screen.dart';
import 'package:sleep_tracker/settings_screen.dart';
import 'package:sleep_tracker/sleep_session_provider.dart';
import 'package:sleep_tracker/sleep_session.dart';
import 'nothern_lights.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // JSON
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  List<SleepSession> sessionHistory = [];
  Map<String, int> commonSettings = {};

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
        ? AppLocalizations.of(context)!.enabled
        : AppLocalizations.of(context)!.disabled;
    String commonSound = commonSettings['soundEnabled'] != null &&
            commonSettings['soundEnabled']! > (sessionHistory.length / 2)
        ? AppLocalizations.of(context)!.enabled
        : AppLocalizations.of(context)!.disabled;

    return Card(
      color: Colors.white.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.mostCommonSettings,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(AppLocalizations.of(context)!.vibration + ": $commonVibration"),
            Text(AppLocalizations.of(context)!.sound + ": $commonSound"),
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
            title: Text(AppLocalizations.of(context)!.session + "${index + 1}"),
            subtitle: Text(
              AppLocalizations.of(context)!.start + ": ${session.startTime!.hour}:${session.startTime!.minute}\n" +
              AppLocalizations.of(context)!.end + ": ${session.endTime!.hour}:${session.endTime!.minute}\n" +
              AppLocalizations.of(context)!.vibration + ": ${session.vibrationEnabled ? AppLocalizations.of(context)!.enabled : AppLocalizations.of(context)!.disabled}\n" +
              AppLocalizations.of(context)!.sound + ": ${session.soundEnabled ? AppLocalizations.of(context)!.enabled : AppLocalizations.of(context)!.disabled}",
            ),
          ),
        );
      },
    );
  }
}
