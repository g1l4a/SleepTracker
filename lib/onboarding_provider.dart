import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingProvider = StateProvider<bool>((ref) {
  return false; 
});

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(false);

  void completeOnboarding() {
    state = true; 
  }
}