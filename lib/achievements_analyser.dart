import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_tracker/achievements_provider.dart';
import 'package:sleep_tracker/sleep_session.dart';
import 'package:sleep_tracker/sleep_session_provider.dart';
import 'package:sleep_tracker/statistics.dart';
import 'package:sleep_tracker/statistics_provider.dart';

bool _isDifferentDay(DateTime date1, DateTime date2) {
  return date1.year != date2.year || date1.month != date2.month || date1.day != date2.day;
}

void analyse(WidgetRef ref) async {
  print('Analyse session');
  await ref.read(statisticsProvider.notifier).loadFromPreferences();
  //await ref.read(sleepSessionProvider.notifier).loadFromPreferences();
  await ref.read(achievementsProvider.notifier).loadFromPreferences();
  Statistics stats = ref.read(statisticsProvider);
  SleepSession newSession = ref.read(sleepSessionProvider);

  // id 0 - "First session" is automatically completed
  ref.read(achievementsProvider.notifier).complete(0);

  // id 1 - "Day sleep" - session is in daytime
  if((newSession.startTime != null) && (newSession.endTime != null)) {
    if((newSession.startTime!.hour >= 12) && (newSession.endTime!.hour < 16)) {
      ref.read(achievementsProvider.notifier).complete(1);
    }
  }

  if(newSession.endTime != null) {
    DateTime newSessionEnd = DateTime.now().copyWith(hour: newSession.endTime!.hour, minute: newSession.endTime!.minute);

    // if session ended in new day (though it is very conditional), treat it as addition in consecutive days / just days
    // the reset in consecutive days is handled on stats loading in achievements_provider.dart
    if(stats.lastSessionEnd != null) {
      if(_isDifferentDay(stats.lastSessionEnd!, newSessionEnd)) {
        ref.read(statisticsProvider.notifier).addConsDays();
        stats = ref.read(statisticsProvider);
      }
    }
    else {
      // if there was no record on prevoius end, just add a day
      ref.read(statisticsProvider.notifier).addConsDays();
    }
    ref.read(statisticsProvider.notifier).changeSessionEnd(newSessionEnd);
  }

  // id 2, 3 are same in principle
  if(stats.curConsDays >= 30) {
    ref.read(achievementsProvider.notifier).complete(3);
  } else if(stats.curConsDays >= 7) {
    ref.read(achievementsProvider.notifier).complete(2);
  }

  // id 4 same but with just days, not consecutive
  if(stats.total >= 60) {
    ref.read(achievementsProvider.notifier).complete(4);
  }
}