import 'package:flutter/material.dart';

class NorthernLights extends StatefulWidget {
  const NorthernLights({
    super.key,
    required this.beginDirection,
    required this.endDirection,
  });

  final Alignment beginDirection;
  final Alignment endDirection;

  @override
  _NorthernLightsState createState() => _NorthernLightsState();
}

class _NorthernLightsState extends State<NorthernLights> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: NorthernLightsPainter(
            _animation.value,
            beginDirection: widget.beginDirection,
            endDirection: widget.endDirection,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class NorthernLightsPainter extends CustomPainter {
  final double animationValue;
  final Alignment beginDirection;
  final Alignment endDirection;

  NorthernLightsPainter(this.animationValue, {required this.beginDirection, required this.endDirection});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color.fromARGB(255, 153, 133, 223).withOpacity(0.5 * animationValue),
          const Color.fromARGB(255, 99, 60, 170).withOpacity(0.5 * animationValue),
          const Color.fromARGB(255, 63, 22, 117).withOpacity(0.5 * animationValue),
          const Color.fromARGB(255, 0, 201, 197).withOpacity(0.5 * animationValue),
          const Color.fromARGB(255, 159, 255, 146).withOpacity(0.5 * animationValue),
          const Color.fromARGB(255, 0, 162, 255).withOpacity(0.5 * animationValue),
          const Color.fromARGB(255, 255, 182, 193).withOpacity(0.5 * animationValue),
          const Color.fromARGB(255, 0, 43, 100).withOpacity(0.5 * animationValue),
        ],
        begin: beginDirection,
        end: endDirection,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(NorthernLightsPainter oldDelegate) {
    return true;
  }
}
