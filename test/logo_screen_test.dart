import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_tracker/logo_screen.dart'; 
import 'package:sleep_tracker/onboarding_provider.dart'; 
import 'package:sleep_tracker/home_screen.dart'; 
import 'package:sleep_tracker/onboarding_screen.dart'; 

void main() {
  
  final container = ProviderContainer();

  tearDown(() {
    container.dispose();
  });

  testWidgets('shows Sleep Tracker logo and navigates to HomeScreen after onboarding', (WidgetTester tester) async {
    
    container.read(onboardingProvider.notifier).completeOnboarding();

    
    await tester.pumpWidget(const
      ProviderScope(
        child: MaterialApp(
          home: LogoScreen(),
        ),
      ),
    );

    
    expect(find.text('Sleep Tracker'), findsOneWidget);
    expect(find.byIcon(Icons.nights_stay_outlined), findsOneWidget);
    expect(find.byType(OnboardingScreen), findsNothing);
  });

  testWidgets('navigates to OnboardingScreen if onboarding not completed', (WidgetTester tester) async {
  
    await tester.pumpWidget(const
      ProviderScope(
        child: MaterialApp(
          home: LogoScreen(),
        ),
      ),
    );

    expect(find.byType(HomeScreen), findsNothing);
  });
}
