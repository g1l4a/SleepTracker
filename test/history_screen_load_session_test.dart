import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_tracker/history_screen.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    SharedPreferences.setMockInitialValues({});
  });

  Widget createWidgetUnderTest() {
    return const ProviderScope(
      child: MaterialApp(
        home: HistoryScreen(),
      ),
    );
  }

  testWidgets('displays session history after loading',
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

    expect(find.text("Most Common Settings"), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(2));
    expect(find.text("Session 1"), findsOneWidget);
    expect(
        find.text(
            "Start: 22:30\nEnd: 23:0\nVibration: Enabled\nSound: Disabled"),
        findsOneWidget);
    expect(find.text("Session 2"), findsOneWidget);
    expect(
        find.text(
            "Start: 23:15\nEnd: 23:45\nVibration: Disabled\nSound: Enabled"),
        findsOneWidget);
  });
}
