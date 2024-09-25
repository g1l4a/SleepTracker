import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_tracker/statistics.dart';

class StatisticsNotifier extends StateNotifier<Statistics> {
  static const String statsCurConsDaysKey = 'statistics/CCD';
  static const String statsMaxConsDaysKey = 'statistics/MCD';
  static const String statsTotalKey = 'statistics/total';
  static const String statsLastEndTimeKey = 'statistics/lastEndTime';

  StatisticsNotifier() : super(Statistics(curConsDays: 0, maxConsDays: 0, total: 0)) {
    loadFromPreferences();
  }

  void addConsDays({int n=1}) {
    int newCons = state.curConsDays + n;

    state = state.copyWith(
      curConsDays: newCons,
      maxConsDays: state.maxConsDays < newCons ? newCons : state.maxConsDays,
      total: state.total + n
    );
    _saveToPreferences();
  }

  void changeSessionEnd(DateTime lastSessionEnd) {
    state = state.copyWith(lastSessionEnd: lastSessionEnd);
    _saveToPreferences();
  }

  void reset() {
    state = Statistics(curConsDays: 0, maxConsDays: 0, total: 0);
    _saveToPreferences();
  }

  Future<void> _saveToPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(statsCurConsDaysKey, state.curConsDays);
    prefs.setInt(statsMaxConsDaysKey, state.curConsDays);
    prefs.setInt(statsTotalKey, state.curConsDays);
      prefs.setString(statsLastEndTimeKey, state.lastSessionEnd.toString());
  }

  Future<void> loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    DateTime? lastEndTimeDT;
    try {
      String? lastEndTime = prefs.getString(statsLastEndTimeKey);
      lastEndTimeDT = lastEndTime != null ? DateTime.parse(lastEndTime) : null;
    } catch (_) {
      lastEndTimeDT = null;
    }

    int curConsDays = prefs.getInt(statsCurConsDaysKey) ?? 0;
    if(lastEndTimeDT != null) {
      if(DateTime.now().difference(lastEndTimeDT).abs() > const Duration(hours: 20)) {
        curConsDays = 0;
      }
    }

    state = Statistics(
      curConsDays: curConsDays,
      maxConsDays: prefs.getInt(statsMaxConsDaysKey) ?? 0,
      total: prefs.getInt(statsTotalKey) ?? 0,
      lastSessionEnd: lastEndTimeDT
    );
  }
}

final statisticsProvider = StateNotifierProvider<StatisticsNotifier, Statistics>((ref) {
  return StatisticsNotifier();
});
