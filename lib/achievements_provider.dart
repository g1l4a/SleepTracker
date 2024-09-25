import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_tracker/achievement.dart';
import 'dart:convert';

class AchievementsNotifier extends StateNotifier<List<Achievement>> {
  static const String achievementsKey = 'achievements';

  AchievementsNotifier() : super([]) {
    loadFromPreferences();
  }

  void complete(int id) {
    for(int i=0; i < state.length; ++i) {
      if(state[i].id == id) {
        state[i].complete();
        break;
      }
    }
    _saveToPreferences();
    state = [...state]; // now it should reload UI as list changed
  }

  void reset() {
    state = achievementDescriptions.map((x) => x.copyWith()).toList();
  }

  Future<void> _saveToPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> achievementsJsons = state.map((achievement) { return jsonEncode(achievement.toMap()); }).toList();
    prefs.setStringList(achievementsKey, achievementsJsons);
  }

  Future<void> loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final achievementsJsons = prefs.getStringList(achievementsKey);
    if(achievementsJsons != null){
      state = achievementsJsons.map((item) { return Achievement.fromMap(jsonDecode(item)); }).toList();
    }
    else {
      state = achievementDescriptions.map((x) => x.copyWith()).toList();
    }
  }

}


final achievementsProvider = StateNotifierProvider<AchievementsNotifier, List<Achievement>>((ref) {
  return AchievementsNotifier();
});
