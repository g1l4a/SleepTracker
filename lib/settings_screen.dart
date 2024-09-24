import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_screen_provider.dart';
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
