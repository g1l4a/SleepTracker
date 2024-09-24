import 'package:flutter/material.dart';

// upload and download session history from sleep_session using shared_prefernces methods
// add nothern_lights as background
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Session History'),
      ),
      body: const Center(
        child: Text('Statistics of sleep sessions will be shown here.'),
      ),
    );
  }
}
