import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Session History'),
      ),
      body: Center(
        child: Text('Statistics of sleep sessions will be shown here.'),
      ),
    );
  }
}
