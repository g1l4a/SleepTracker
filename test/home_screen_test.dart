import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_tracker/home_screen.dart';

Widget createHomeScreen() {
  return const ProviderScope(
    child: MaterialApp(
      home: HomeScreen(),
    ),
  );
}

void main() {
  testWidgets('HomeScreen displays the correct initial UI', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(createHomeScreen());

    // Act
    final startButtonFinder = find.text('Start\nSession');
    final timeLeftFinder = find.text('Time left: 00:00');
    final startTimeFinder = find.text('Start Time:');
    final endTimeFinder = find.text('End Time:');

    // Assert
    expect(startButtonFinder, findsOneWidget);
    expect(timeLeftFinder, findsOneWidget);
    expect(startTimeFinder, findsOneWidget);
    expect(endTimeFinder, findsOneWidget);
  });
}
