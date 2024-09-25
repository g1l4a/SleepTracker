import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';
import 'onboarding_provider.dart';
import 'nothern_lights.dart';

class LogoScreen extends ConsumerStatefulWidget {
  const LogoScreen({super.key});

  @override
  _LogoScreenState createState() => _LogoScreenState();
}

class _LogoScreenState extends ConsumerState<LogoScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startNavigationTimer();
  }

  void _startNavigationTimer() {
    _timer = Timer(const Duration(seconds: 5), () {
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() {
    final onboardingCompleted = ref.read(onboardingProvider);
    if (onboardingCompleted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 0, 6, 88),
          ),
          // Northern Lights animation
          const Center(
            child: NorthernLights(beginDirection: Alignment.bottomRight, endDirection: Alignment.topLeft),
          ),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.nights_stay_outlined, size: 100, color: Color.fromARGB(255, 255, 243, 134)),
                SizedBox(height: 20),
                Text(
                  'Sleep Tracker',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
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
