import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_tracker/session_summary_screen.dart';
import 'sleep_session_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SleepSessionScreen extends ConsumerWidget {
  const SleepSessionScreen({super.key});

  void _endSession(BuildContext context, WidgetRef ref) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SessionSummaryScreen(), 
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sleepSession = ref.watch(sleepSessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).sessionProgress),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).remainingTime + '${sleepSession.getRemainingTime().inMinutes}' + AppLocalizations.of(context).minutes,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _endSession(context, ref),
              child: Text(AppLocalizations.of(context).endSession),
            ),
          ],
        ),
      ),
    );
  }
}
