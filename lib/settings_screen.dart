import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_screen_provider.dart';
import 'statistics_provider.dart';
import 'achievements_provider.dart';
import 'nothern_lights.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'settings_screen_shared_preferences.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.preferences,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.enVibration, style: TextStyle(color: Colors.white)),
                  value: settings.vibrationEnabled,
                  onChanged: notifier.toggleVibration,
                ),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.enSound, style: TextStyle(color: Colors.white)),
                  value: settings.soundEnabled,
                  onChanged: notifier.toggleSound,
                ),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.enNotify, style: TextStyle(color: Colors.white)),
                  value: settings.notificationsEnabled,
                  onChanged: notifier.toggleNotifications,
                ),
                /*SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.enDark, style: TextStyle(color: Colors.white)),
                  value: settings.isDarkMode,
                  onChanged: notifier.toggleTheme,
                ),*/
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.language,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                ListTile(
                  title: const Text('English', style: TextStyle(color: Colors.white)),
                  leading: Radio<String>(
                    value: 'en',
                    groupValue: settings.language,
                    onChanged: (String? lang) {
                      if (lang != null) {
                        notifier.setLanguage(lang);
                        _changeLocale(lang, notifier);
                      }
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Русский', style: TextStyle(color: Colors.white)),
                  leading: Radio<String>(
                    value: 'ru',
                    groupValue: settings.language,
                    onChanged: (String? lang) {
                      if (lang != null) {
                        notifier.setLanguage(lang);
                        _changeLocale(lang, notifier);
                      }
                    },
                  ),
                ),
              TextButton(
                child: Text(AppLocalizations.of(context)!.btDataReset, style: TextStyle(
                    color: Colors.grey.shade200,
                    fontSize: 24,
                    fontFamily: 'Montserrat'
                    ).copyWith(fontSize: 16, color: Colors.grey)),
                onPressed: () async {
                  bool? confirmed = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(AppLocalizations.of(context)!.dataResetTitle),
                        content: Text(AppLocalizations.of(context)!.dataResetText),
                        actions: [
                          TextButton(
                            onPressed: () { Navigator.of(context).pop(false); },
                            child: Text(AppLocalizations.of(context)!.btCancel),
                          ),
                          TextButton(
                            onPressed: () { Navigator.of(context).pop(true); },
                            child: Text(AppLocalizations.of(context)!.btConfirm),
                          ),
                        ],
                      );
                    },
                  );
                  
                  if (confirmed == true) {
                    ref.read(achievementsProvider.notifier).reset();
                    ref.read(statisticsProvider.notifier).reset();
                  }
                },
              ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _changeLocale(String lang, SettingsNotifier notifier) {
    SettingsSharedPreferences.saveSetting('language', lang);
    notifier.setLanguage(lang);
  }
}
