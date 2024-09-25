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
        state[i].setIsObtained();
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
    Map<String, bool> achievementRecord = {for (var a in state) '${a.id}': a.isObtained};
    prefs.setString(achievementsKey, jsonEncode(achievementRecord));
  }

  Future<void> loadFromPreferences() async {
    List<Achievement> temp = achievementDescriptions.map((x) => x.copyWith()).toList();

    final prefs = await SharedPreferences.getInstance();
    final achievementsJsons = prefs.getString(achievementsKey);
    if(achievementsJsons != null){
      dynamic achievementRecord = jsonDecode(achievementsJsons);
      for(int i=0; i<temp.length; i++) {
        temp[i].setIsObtained(state: achievementRecord['${temp[i].id}']);
      }
    }
    state = temp;
  }

}


final achievementsProvider = StateNotifierProvider<AchievementsNotifier, List<Achievement>>((ref) {
  return AchievementsNotifier();
});
