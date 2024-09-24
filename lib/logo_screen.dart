import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';
import 'onboarding_provider.dart';
import 'dart:math';
import 'nothern_lights.dart';

class LogoScreen extends ConsumerWidget {
  const LogoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingCompleted = ref.watch(onboardingProvider);

    Future.delayed(const Duration(seconds: 5), () {
      if (onboardingCompleted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnboardingScreen()));
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          
          Container(
            color: const Color.fromARGB(255, 0, 6, 88), 
          ),
          // Northern Lights animation
          const Center(
            child: NorthernLights(beginDirection: Alignment.bottomRight, endDirection: Alignment.topLeft,),
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

class StarrySkyPainter extends CustomPainter {
  final int numberOfStars;
  final Random random = Random();

  StarrySkyPainter({this.numberOfStars = 100}); 

  @override
  void paint(Canvas canvas, Size size) {

    // Draw random stars
    for (int i = 0; i < numberOfStars; i++) {
      final double starSize = random.nextDouble() * 3; 
      final double opacity = random.nextDouble() * 0.8 + 0.2; 
      final Paint starPaint = Paint()..color = Colors.white.withOpacity(opacity);
      
      final Offset starOffset = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );

      canvas.drawCircle(starOffset, starSize, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
