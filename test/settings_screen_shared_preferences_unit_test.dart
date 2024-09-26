import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'package:sleep_tracker/settings_screen_shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  test('saves and loads boolean setting', () async {
    await SettingsSharedPreferences.saveSetting('testBool', true);
    expect(await SettingsSharedPreferences.loadSetting('testBool', false), true);
  });

  test('saves and loads string setting', () async {
    await SettingsSharedPreferences.saveSetting('testString', 'hello');
    expect(await SettingsSharedPreferences.loadSetting('testString', ''), 'hello');
  });

  test('returns default value if key does not exist', () async {
    expect(await SettingsSharedPreferences.loadSetting('nonexistentKey', false), false);
    expect(await SettingsSharedPreferences.loadSetting('nonexistentKey', 'default'), 'default');
  });
}
