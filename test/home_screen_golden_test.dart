import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_tracker/home_screen.dart'; // Import your actual screen

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Initialize SharedPreferences with mock values
    SharedPreferences.setMockInitialValues({}); // Provide mock values if necessary
  });

  testWidgets('Golden test for HomeScreen layout', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: HomeScreen()))); // Pump your widget

    // Add the golden file comparison
    await expectLater(
      find.byType(HomeScreen),
      matchesGoldenFile('goldens/home_screen.png'),
    );
  });
}
