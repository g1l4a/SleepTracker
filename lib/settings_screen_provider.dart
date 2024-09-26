import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Settings {
  final bool isDarkMode;
  final bool vibrationEnabled;
  final bool soundEnabled;
  final String language;
  final bool notificationsEnabled;

  Settings({
    this.isDarkMode = true,
    this.vibrationEnabled = false,
    this.soundEnabled = true,
    this.language = 'en',
    this.notificationsEnabled = false,
  });

  Settings copyWith({
    bool? isDarkMode,
    bool? vibrationEnabled,
    bool? soundEnabled,
    String? language,
    bool? notificationsEnabled,
  }) {
    return Settings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier() : super(Settings(isDarkMode: true)) {
    loadSettings();
  }

  bool get isDarkMode => state.isDarkMode;

  void toggleTheme(bool isDarkMode) {
    state = state.copyWith(isDarkMode: isDarkMode);
    saveSettings();
  }


  void toggleVibration(bool isEnabled) {
    state = state.copyWith(vibrationEnabled: isEnabled);
    saveSettings();
  }

  void toggleSound(bool isEnabled) {
    state = state.copyWith(soundEnabled: isEnabled);
    saveSettings();
  }

  void setLanguage(String lang) {
    state = state.copyWith(language: lang);
    saveSettings();
  }

  void toggleNotifications(bool isEnabled) {
    state = state.copyWith(notificationsEnabled: isEnabled);
    saveSettings();
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', state.isDarkMode);
    await prefs.setBool('vibrationEnabled', state.vibrationEnabled);
    await prefs.setBool('soundEnabled', state.soundEnabled);
    await prefs.setString('language', state.language);
    await prefs.setBool('notificationsEnabled', state.notificationsEnabled);
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(
      isDarkMode: prefs.getBool('isDarkMode') ?? false,
      vibrationEnabled: prefs.getBool('vibrationEnabled') ?? false,
      soundEnabled: prefs.getBool('soundEnabled') ?? true,
      language: prefs.getString('language') ?? 'en',
      notificationsEnabled: prefs.getBool('notificationsEnabled') ?? false,
    );
  }
}


final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>((ref) {
  return SettingsNotifier();
});
