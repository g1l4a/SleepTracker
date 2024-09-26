import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_tracker/logo_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  tz.initializeTimeZones();
  runApp(const ProviderScope(child: ProjectApp()));
}

class ProjectApp extends StatelessWidget {
  const ProjectApp({super.key});  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LogoScreen(),
    );
  }
}