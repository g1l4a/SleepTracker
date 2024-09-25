import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

  testWidgets('initial state shows empty session history',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Check if the common settings title is displayed
    expect(find.text("Most Common Settings"), findsOneWidget);
    // Ensure there are no session entries in the ListView
    expect(find.byType(ListTile), findsNothing);
  });
}
