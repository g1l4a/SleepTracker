import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_tracker/logo_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'settings_screen_provider.dart';

void main() {
  tz.initializeTimeZones();
  runApp(const ProviderScope(child: ProjectApp()));
}

class ProjectApp extends ConsumerWidget  {
  const ProjectApp({super.key});  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider); 
    
    return MaterialApp(
      title: 'Project',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      locale: Locale(settings.language),
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LogoScreen(),
    );
  }
}