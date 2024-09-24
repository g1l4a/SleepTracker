import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier();
});

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(false) {
    _loadOnboardingStatus();
  }

  Future<void> completeOnboarding() async {
    state = true;
    await _saveOnboardingStatus();
  }

  Future<void> _saveOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', state);
  }

  Future<void> _loadOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingComplete = prefs.getBool('onboardingComplete') ?? false;
    state = onboardingComplete;
  }
}
