import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_tracker/onboarding_screen.dart';
import 'package:sleep_tracker/settings_screen_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {

  testWidgets('displays the first onboarding page correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
    
      ProviderScope(
        child: MaterialApp(
          title: 'Project',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          locale: const Locale('en'), // Set a default locale
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const OnboardingScreen(),
        ),
      )
    );

    expect(find.text('Welcome to Sleep Tracker'), findsOneWidget);
    expect(find.text('Track your sleep for a better tomorrow.'), findsOneWidget);
    expect(find.byIcon(Icons.bedtime), findsOneWidget);
  });

  
}
