import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_tracker/onboarding_screen.dart';

void main() {

  testWidgets('displays the first onboarding page correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const
      ProviderScope(
        child: MaterialApp(
          home: OnboardingScreen(),
        ),
      ),
    );

    expect(find.text('Welcome to Sleep Tracker'), findsOneWidget);
    expect(find.text('Track your sleep for a better tomorrow.'), findsOneWidget);
    expect(find.byIcon(Icons.bedtime), findsOneWidget);
  });

  
}
