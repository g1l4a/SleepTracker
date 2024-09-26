import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionSummary {
  final Duration duration;
  final int sleepRating;

  SessionSummary({required this.duration, this.sleepRating = 0});

  SessionSummary copyWith({Duration? duration, int? sleepRating}) {
    return SessionSummary(
      duration: duration ?? this.duration,
      sleepRating: sleepRating ?? this.sleepRating,
    );
  }
}

class SessionSummaryNotifier extends StateNotifier<SessionSummary> {
  SessionSummaryNotifier() : super(SessionSummary(duration: Duration.zero)) {
    loadFromPreferences();
  }

  void setDuration(Duration duration)
  {
    state = state.copyWith(duration: duration);
    _saveToPreferences();
  }

  void rateSleep(int rating) {
    state = state.copyWith(sleepRating: rating);
    _saveToPreferences();
  }

  Future<void> loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final durationMinutes = prefs.getInt('sessionDuration') ?? 0;
    final sleepRating = prefs.getInt('sleepRating') ?? 0;

    state = state.copyWith(
      duration: Duration(minutes: durationMinutes),
      sleepRating: sleepRating,
    );
  }

  Future<void> _saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sessionDuration', state.duration.inMinutes);
    await prefs.setInt('sleepRating', state.sleepRating);
  }
}

final sessionSummaryProvider =
    StateNotifierProvider<SessionSummaryNotifier, SessionSummary>((ref) {
  return SessionSummaryNotifier();
});
