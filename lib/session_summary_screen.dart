import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'session_summary_screen_provider.dart';
import 'nothern_lights.dart';

class SessionSummaryScreen extends ConsumerWidget {
  const SessionSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionSummary = ref.watch(sessionSummaryProvider);
    final notifier = ref.read(sessionSummaryProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [

          Container(
            color: const Color.fromARGB(255, 0, 6, 88),
          ),

          const Center(
            child: NorthernLights(
              beginDirection: Alignment.bottomRight,
              endDirection: Alignment.topLeft,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Session Summary',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 20),
                
                Text(
                  'You slept for ${sessionSummary.duration.inHours} hours and ${sessionSummary.duration.inMinutes % 60} minutes.',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 30),

                const Text(
                  'How was your sleep?',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () => notifier.rateSleep(index + 1),
                      child: Icon(
                        sessionSummary.sleepRating > index
                            ? Icons.sentiment_very_satisfied
                            : Icons.sentiment_dissatisfied,
                        color: sessionSummary.sleepRating > index
                            ? Colors.yellow
                            : Colors.white,
                        size: 40,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

