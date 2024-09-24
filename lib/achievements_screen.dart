import 'package:flutter/material.dart';

// add nothern_lights as background
class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: const Center(
        child: Text('Achievements and badges will be displayed here.'),
      ),
    );
  }
}
