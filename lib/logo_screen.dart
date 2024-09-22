import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';
import 'onboarding_provider.dart';

class LogoScreen extends ConsumerWidget {
  const LogoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingCompleted = ref.watch(onboardingProvider);

    Future.delayed(Duration(seconds: 3), () {
      if (onboardingCompleted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
      }
    });

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.nights_stay, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text('Sleep Tracker', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
