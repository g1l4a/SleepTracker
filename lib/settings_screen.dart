import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_screen_provider.dart';
import 'statistics_provider.dart';
import 'achievements_provider.dart';
import 'nothern_lights.dart';

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
                const Text(
                  'Preferences',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SwitchListTile(
                  title: const Text('Enable Vibration', style: TextStyle(color: Colors.white)),
                  value: settings.vibrationEnabled,
                  onChanged: notifier.toggleVibration,
                ),
                SwitchListTile(
                  title: const Text('Enable Sound', style: TextStyle(color: Colors.white)),
                  value: settings.soundEnabled,
                  onChanged: notifier.toggleSound,
                ),
                SwitchListTile(
                  title: const Text('Enable Sleep Preparation Notifications', style: TextStyle(color: Colors.white)),
                  value: settings.notificationsEnabled,
                  onChanged: notifier.toggleNotifications,
                ),
                SwitchListTile(
                  title: const Text('Enable Dark Mode', style: TextStyle(color: Colors.white)),
                  value: settings.isDarkMode,
                  onChanged: notifier.toggleTheme,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Language',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                ListTile(
                  title: const Text('English', style: TextStyle(color: Colors.white)),
                  leading: Radio<String>(
                    value: 'eng',
                    groupValue: settings.language,
                    onChanged: (String? lang) {
                      if (lang != null) {
                        notifier.setLanguage(lang);
                      }
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Russian', style: TextStyle(color: Colors.white)),
                  leading: Radio<String>(
                    value: 'rus',
                    groupValue: settings.language,
                    onChanged: (String? lang) {
                      if (lang != null) {
                        notifier.setLanguage(lang);
                      }
                    },
                  ),
                ),
              TextButton(
                child: Text('Reset data', style: TextStyle(
                    color: Colors.grey.shade200,
                    fontSize: 24,
                    fontFamily: 'Montserrat'
                    ).copyWith(fontSize: 16, color: Colors.grey)),
                onPressed: () async {
                  bool? confirmed = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Wait a second!"),
                        content: const Text("Are you sure you want to reset achievements and statistics?"),
                        actions: [
                          TextButton(
                            onPressed: () { Navigator.of(context).pop(false); },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () { Navigator.of(context).pop(true); },
                            child: const Text("Confirm"),
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
}
