// lib/pages/onboarding/question_flow_widgets/mascot_widget.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;

enum MascotMood {
  curious,
  thinking,
  excited,
  happy,
}

class MascotWidget extends StatefulWidget {
  final MascotMood mood;

  const MascotWidget({
    super.key,
    required this.mood,
  });

  @override
  State<MascotWidget> createState() => _MascotWidgetState();
}

class _MascotWidgetState extends State<MascotWidget>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _bounceController;
  late AnimationController _blinkController;
  late AnimationController _waveController;

  late Animation<double> _floatAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _blinkAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();

    // Floating animation (continuous)
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0, end: 15).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Bounce animation (on entry)
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.elasticOut,
      ),
    );

    // Blink animation (periodic)
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _blinkAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );

    // Wave animation (occasional)
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _waveAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    // Start animations
    _bounceController.forward();
    _startBlinkCycle();
    _startWaveCycle();
  }

  void _startBlinkCycle() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        _blinkController.forward().then((_) {
          _blinkController.reverse().then((_) {
            _startBlinkCycle();
          });
        });
      }
    });
  }

  void _startWaveCycle() {
    Future.delayed(const Duration(milliseconds: 4000), () {
      if (mounted) {
        _waveController.forward().then((_) {
          _waveController.reverse().then((_) {
            _startWaveCycle();
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bounceController.dispose();
    _blinkController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _floatAnimation,
        _bounceAnimation,
        _blinkAnimation,
        _waveAnimation,
      ]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_floatAnimation.value),
          child: Transform.scale(
            scale: _bounceAnimation.value,
            child: SizedBox(
              width: 200,
              height: 200,
              child: CustomPaint(
                painter: _MascotPainter(
                  mood: widget.mood,
                  blinkValue: _blinkAnimation.value,
                  waveValue: _waveAnimation.value,
                  primaryColor: Theme.of(context).colorScheme.primary,
                  secondaryColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MascotPainter extends CustomPainter {
  final MascotMood mood;
  final double blinkValue;
  final double waveValue;
  final Color primaryColor;
  final Color secondaryColor;

  _MascotPainter({
    required this.mood,
    required this.blinkValue,
    required this.waveValue,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw shadow
    paint.color = Colors.black.withOpacity(0.1);
    canvas.drawCircle(
      Offset(center.dx, center.dy + 90),
      50,
      paint,
    );

    // Draw body (rounded square)
    paint.color = primaryColor;
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 140, height: 140),
      const Radius.circular(35),
    );
    canvas.drawRRect(bodyRect, paint);

    // Draw body highlight
    paint.color = Colors.white.withOpacity(0.2);
    final highlightRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy - 10),
        width: 120,
        height: 60,
      ),
      const Radius.circular(30),
    );
    canvas.drawRRect(highlightRect, paint);

    // Draw antenna
    paint.color = primaryColor;
    paint.strokeWidth = 4;
    paint.style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(center.dx, center.dy - 70),
      Offset(center.dx, center.dy - 90),
      paint,
    );

    paint.style = PaintingStyle.fill;
    paint.color = secondaryColor;
    canvas.drawCircle(Offset(center.dx, center.dy - 95), 8, paint);

    // Draw eyes based on mood
    _drawEyes(canvas, center, paint);

    // Draw mouth based on mood
    _drawMouth(canvas, center, paint);

    // Draw waving arm
    if (waveValue > 0) {
      _drawArm(canvas, center, paint);
    }
  }

  void _drawEyes(Canvas canvas, Offset center, Paint paint) {
    paint.color = Colors.white;

    // Left eye
    final leftEyeHeight = 12.0 * blinkValue;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - 25, center.dy - 10),
        width: 16,
        height: leftEyeHeight,
      ),
      paint,
    );

    // Right eye
    final rightEyeHeight = 12.0 * blinkValue;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + 25, center.dy - 10),
        width: 16,
        height: rightEyeHeight,
      ),
      paint,
    );

    // Pupils
    if (blinkValue > 0.3) {
      paint.color = primaryColor;

      // Left pupil
      canvas.drawCircle(
        Offset(center.dx - 25, center.dy - 10),
        6,
        paint,
      );

      // Right pupil
      canvas.drawCircle(
        Offset(center.dx + 25, center.dy - 10),
        6,
        paint,
      );

      // Eye sparkles
      paint.color = Colors.white;
      canvas.drawCircle(
        Offset(center.dx - 23, center.dy - 12),
        2,
        paint,
      );
      canvas.drawCircle(
        Offset(center.dx + 27, center.dy - 12),
        2,
        paint,
      );
    }
  }

  void _drawMouth(Canvas canvas, Offset center, Paint paint) {
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;

    switch (mood) {
      case MascotMood.curious:
      // Small O mouth
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(center.dx, center.dy + 25),
            width: 20,
            height: 25,
          ),
          paint,
        );
        break;

      case MascotMood.thinking:
      // Small line mouth
        paint.strokeWidth = 3;
        paint.style = PaintingStyle.stroke;
        paint.strokeCap = StrokeCap.round;
        canvas.drawLine(
          Offset(center.dx - 15, center.dy + 25),
          Offset(center.dx + 15, center.dy + 25),
          paint,
        );
        break;

      case MascotMood.excited:
      // Big smile
        final path = Path();
        path.moveTo(center.dx - 25, center.dy + 20);
        path.quadraticBezierTo(
          center.dx,
          center.dy + 40,
          center.dx + 25,
          center.dy + 20,
        );
        path.lineTo(center.dx + 25, center.dy + 25);
        path.quadraticBezierTo(
          center.dx,
          center.dy + 38,
          center.dx - 25,
          center.dy + 25,
        );
        path.close();
        canvas.drawPath(path, paint);
        break;

      case MascotMood.happy:
      // Happy smile
        final path = Path();
        path.moveTo(center.dx - 20, center.dy + 20);
        path.quadraticBezierTo(
          center.dx,
          center.dy + 35,
          center.dx + 20,
          center.dy + 20,
        );
        path.lineTo(center.dx + 20, center.dy + 24);
        path.quadraticBezierTo(
          center.dx,
          center.dy + 32,
          center.dx - 20,
          center.dy + 24,
        );
        path.close();
        canvas.drawPath(path, paint);
        break;
    }
  }

  void _drawArm(Canvas canvas, Offset center, Paint paint) {
    paint.color = primaryColor;
    paint.style = PaintingStyle.fill;

    final armRotation = math.sin(waveValue * math.pi * 2) * 0.3;

    canvas.save();
    canvas.translate(center.dx + 70, center.dy);
    canvas.rotate(armRotation);

    // Arm
    final armRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-10, -5, 30, 10),
      const Radius.circular(5),
    );
    canvas.drawRRect(armRect, paint);

    // Hand
    paint.color = secondaryColor;
    canvas.drawCircle(const Offset(20, 0), 8, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(_MascotPainter oldDelegate) {
    return oldDelegate.blinkValue != blinkValue ||
        oldDelegate.waveValue != waveValue ||
        oldDelegate.mood != mood;
  }
}