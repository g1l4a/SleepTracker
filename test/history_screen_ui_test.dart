import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_tracker/history_screen.dart';

void main() {
  Widget createWidgetUnderTest() {
    return ProviderScope(
      child: MaterialApp(
        home: HistoryScreen(),
      ),
    );
  }

  testWidgets('displays correct common settings based on session history',
      (WidgetTester tester) async {
    // Mock the SharedPreferences data
    SharedPreferences.setMockInitialValues({
      'sessionCount': 2,
      'session_0':
          '{"startTime":{"hour":22,"minute":30},"endTime":{"hour":23,"minute":0},"vibrationEnabled":true,"soundEnabled":false,"isSessionActive":false}',
      'session_1':
          '{"startTime":{"hour":23,"minute":15},"endTime":{"hour":23,"minute":45},"vibrationEnabled":false,"soundEnabled":true,"isSessionActive":false}',
    });

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle(); // Allow async operations to complete

    // Check common settings
    expect(find.text("Vibration: Enabled"), findsOneWidget);
    expect(find.text("Sound: Enabled"), findsOneWidget);
  });

  testWidgets('displays empty message when no sessions are available',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'sessionCount': 0,
    });

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle(); // Allow async operations to complete

    expect(find.text("Most Common Settings"), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
  });
}
