import 'package:flutter/material.dart';

// notifications: add an notification to remind user to prepare for sleep 1-2 hours before the start time of session
// alarm settings: vibration and sound
// language settings: rus/eng 
// add nothern_lights as background
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Text('Settings Screen'),
      ),
    );
  }
}
