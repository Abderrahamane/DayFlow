// lib/pages/onboarding/question_flow_widgets/robot_character.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;

enum RobotGesture {
  wave,
  takeNotes,
  thinking,
  celebrate,
  idle,
}

class RobotCharacter extends StatefulWidget {
  final RobotGesture gesture;

  const RobotCharacter({
    super.key,
    required this.gesture,
  });

  @override
  State<RobotCharacter> createState() => _RobotCharacterState();
}

class _RobotCharacterState extends State<RobotCharacter>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _bounceController;
  late AnimationController _blinkController;
  late AnimationController _gestureController;

  @override
  void initState() {
    super.initState();

    // Continuous floating
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    // Entry bounce
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Periodic blinking
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // Gesture animation
    _gestureController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _bounceController.forward();
    _startBlinkCycle();
    _playGesture();
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

  void _playGesture() {
    if (widget.gesture != RobotGesture.idle) {
      _gestureController.reset();
      _gestureController.forward();
    }
  }

  @override
  void didUpdateWidget(RobotCharacter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gesture != widget.gesture) {
      _playGesture();
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bounceController.dispose();
    _blinkController.dispose();
    _gestureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _floatController,
        _bounceController,
        _gestureController,
      ]),
      builder: (context, child) {
        final floatValue = math.sin(_floatController.value * math.pi) * 12;

        return Transform.translate(
          offset: Offset(0, floatValue),
          child: Transform.scale(
            scale: Tween<double>(begin: 0.0, end: 1.0)
                .animate(CurvedAnimation(
              parent: _bounceController,
              curve: Curves.elasticOut,
            ))
                .value,
            child: SizedBox(
              width: 220,
              height: 220,
              child: CustomPaint(
                painter: _RobotPainter(
                  gesture: widget.gesture,
                  gestureProgress: _gestureController.value,
                  blinkValue: Tween<double>(begin: 1.0, end: 0.0)
                      .animate(_blinkController)
                      .value,
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

class _RobotPainter extends CustomPainter {
  final RobotGesture gesture;
  final double gestureProgress;
  final double blinkValue;
  final Color primaryColor;
  final Color secondaryColor;

  _RobotPainter({
    required this.gesture,
    required this.gestureProgress,
    required this.blinkValue,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    // // Draw shadow
    // paint.color = Colors.black.withOpacity(0.1);
    // canvas.drawEllipse(
    //   Rect.fromCenter(
    //     center: Offset(center.dx, size.height - 20),
    //     width: 100,
    //     height: 15,
    //   ),
    //   paint,
    // );

    // Draw body
    _drawBody(canvas, center, paint);

    // Draw antenna
    _drawAntenna(canvas, center, paint);

    // Draw face
    _drawFace(canvas, center, paint);

    // Draw arms based on gesture
    _drawArms(canvas, center, paint);

    // Draw legs
    _drawLegs(canvas, center, paint);
  }

  void _drawBody(Canvas canvas, Offset center, Paint paint) {
    // Main body
    final bodyGradient = LinearGradient(
      colors: [primaryColor, secondaryColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final bodyRect = Rect.fromCenter(
      center: center,
      width: 100,
      height: 110,
    );

    paint.shader = bodyGradient.createShader(bodyRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, const Radius.circular(25)),
      paint,
    );
    paint.shader = null;

    // Body highlight
    paint.color = Colors.white.withOpacity(0.2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy - 15),
          width: 80,
          height: 40,
        ),
        const Radius.circular(20),
      ),
      paint,
    );

    // Chest panel
    paint.color = Colors.white.withOpacity(0.3);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + 10),
          width: 50,
          height: 60,
        ),
        const Radius.circular(12),
      ),
      paint,
    );

    // LED indicators on chest
    final ledColors = [Colors.greenAccent, Colors.blueAccent, Colors.redAccent];
    for (int i = 0; i < 3; i++) {
      paint.color = ledColors[i].withOpacity(0.8);
      canvas.drawCircle(
        Offset(center.dx - 15 + i * 15, center.dy + 25),
        3,
        paint,
      );
    }
  }

  void _drawAntenna(Canvas canvas, Offset center, Paint paint) {
    // Antenna stick
    paint.color = primaryColor;
    paint.strokeWidth = 4;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(center.dx, center.dy - 55),
      Offset(center.dx, center.dy - 75),
      paint,
    );

    paint.style = PaintingStyle.fill;

    // Antenna bulb (glowing)
    final bulbGradient = RadialGradient(
      colors: [
        secondaryColor,
        secondaryColor.withOpacity(0.3),
      ],
    );

    paint.shader = bulbGradient.createShader(
      Rect.fromCircle(center: Offset(center.dx, center.dy - 80), radius: 10),
    );
    canvas.drawCircle(Offset(center.dx, center.dy - 80), 10, paint);
    paint.shader = null;

    // Inner bulb glow
    paint.color = Colors.white.withOpacity(0.8);
    canvas.drawCircle(Offset(center.dx - 2, center.dy - 82), 3, paint);
  }

  void _drawFace(Canvas canvas, Offset center, Paint paint) {
    // Eyes
    paint.color = Colors.white;

    // Left eye
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx - 20, center.dy - 15),
          width: 20,
          height: 18 * blinkValue,
        ),
        const Radius.circular(10),
      ),
      paint,
    );

    // Right eye
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx + 20, center.dy - 15),
          width: 20,
          height: 18 * blinkValue,
        ),
        const Radius.circular(10),
      ),
      paint,
    );

    if (blinkValue > 0.3) {
      // Pupils
      paint.color = primaryColor;
      canvas.drawCircle(Offset(center.dx - 20, center.dy - 15), 7, paint);
      canvas.drawCircle(Offset(center.dx + 20, center.dy - 15), 7, paint);

      // Eye sparkles
      paint.color = Colors.white;
      canvas.drawCircle(Offset(center.dx - 18, center.dy - 17), 2.5, paint);
      canvas.drawCircle(Offset(center.dx + 22, center.dy - 17), 2.5, paint);
    }

    // Mouth based on gesture
    _drawMouth(canvas, center, paint);
  }

  void _drawMouth(Canvas canvas, Offset center, Paint paint) {
    paint.color = Colors.white;

    switch (gesture) {
      case RobotGesture.wave:
      case RobotGesture.idle:
      // Happy smile
        final path = Path();
        path.moveTo(center.dx - 18, center.dy + 12);
        path.quadraticBezierTo(
          center.dx,
          center.dy + 25,
          center.dx + 18,
          center.dy + 12,
        );
        path.lineTo(center.dx + 18, center.dy + 16);
        path.quadraticBezierTo(
          center.dx,
          center.dy + 22,
          center.dx - 18,
          center.dy + 16,
        );
        canvas.drawPath(path, paint);
        break;

      case RobotGesture.thinking:
      // Small O mouth
        canvas.drawCircle(Offset(center.dx, center.dy + 15), 6, paint);
        break;

      case RobotGesture.takeNotes:
      // Concentrated line
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = 3;
        paint.strokeCap = StrokeCap.round;
        canvas.drawLine(
          Offset(center.dx - 12, center.dy + 15),
          Offset(center.dx + 12, center.dy + 15),
          paint,
        );
        paint.style = PaintingStyle.fill;
        break;

      case RobotGesture.celebrate:
      // Big excited smile
        final path = Path();
        path.moveTo(center.dx - 22, center.dy + 10);
        path.quadraticBezierTo(
          center.dx,
          center.dy + 30,
          center.dx + 22,
          center.dy + 10,
        );
        path.lineTo(center.dx + 22, center.dy + 15);
        path.quadraticBezierTo(
          center.dx,
          center.dy + 27,
          center.dx - 22,
          center.dy + 15,
        );
        canvas.drawPath(path, paint);
        break;
    }
  }

  void _drawArms(Canvas canvas, Offset center, Paint paint) {
    paint.color = primaryColor;

    switch (gesture) {
      case RobotGesture.wave:
        _drawWavingArm(canvas, center, paint, gestureProgress);
        _drawNormalArm(canvas, center, paint, false);
        break;

      case RobotGesture.takeNotes:
        _drawWritingArms(canvas, center, paint, gestureProgress);
        break;

      case RobotGesture.celebrate:
        _drawCelebratingArms(canvas, center, paint, gestureProgress);
        break;

      default:
        _drawNormalArm(canvas, center, paint, true);
        _drawNormalArm(canvas, center, paint, false);
    }
  }

  void _drawWavingArm(Canvas canvas, Offset center, Paint paint, double progress) {
    canvas.save();
    canvas.translate(center.dx + 50, center.dy - 10);

    // Wave motion
    final waveAngle = math.sin(progress * math.pi * 4) * 0.5;
    canvas.rotate(waveAngle);

    // Upper arm
    paint.color = primaryColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-8, -5, 35, 12),
        const Radius.circular(6),
      ),
      paint,
    );

    // Hand
    paint.color = secondaryColor;
    canvas.drawCircle(const Offset(30, 0), 10, paint);

    // Fingers
    paint.color = primaryColor;
    for (int i = 0; i < 3; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(28 + i * 3, -8 + i * 2, 3, 8),
          const Radius.circular(2),
        ),
        paint,
      );
    }

    canvas.restore();
  }

  void _drawWritingArms(Canvas canvas, Offset center, Paint paint, double progress) {
    // Left arm holding notebook
    canvas.save();
    canvas.translate(center.dx - 50, center.dy + 5);

    paint.color = primaryColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-5, -5, 30, 12),
        const Radius.circular(6),
      ),
      paint,
    );

    // Notebook
    paint.color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(20, -15, 25, 30),
        const Radius.circular(3),
      ),
      paint,
    );

    // Notebook lines
    paint.color = Colors.grey.shade300;
    paint.strokeWidth = 1;
    for (int i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(23, -10 + i * 6),
        Offset(42, -10 + i * 6),
        paint,
      );
    }

    canvas.restore();

    // Right arm writing
    canvas.save();
    canvas.translate(center.dx + 50, center.dy);

    final writeMotion = math.sin(progress * math.pi * 6) * 3;
    canvas.translate(0, writeMotion);

    paint.color = primaryColor;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-35, -5, 35, 12),
        const Radius.circular(6),
      ),
      paint,
    );

    // Pen
    paint.color = Colors.black;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-40, -2, 15, 4),
        const Radius.circular(2),
      ),
      paint,
    );

    canvas.restore();
  }

  void _drawCelebratingArms(Canvas canvas, Offset center, Paint paint, double progress) {
    final angle = math.sin(progress * math.pi * 3) * 0.6;

    // Left arm up
    canvas.save();
    canvas.translate(center.dx - 50, center.dy - 10);
    canvas.rotate(-0.5 + angle);

    paint.color = primaryColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-5, -5, 35, 12),
        const Radius.circular(6),
      ),
      paint,
    );

    paint.color = secondaryColor;
    canvas.drawCircle(const Offset(30, 0), 10, paint);

    canvas.restore();

    // Right arm up
    canvas.save();
    canvas.translate(center.dx + 50, center.dy - 10);
    canvas.rotate(0.5 - angle);

    paint.color = primaryColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-30, -5, 35, 12),
        const Radius.circular(6),
      ),
      paint,
    );

    paint.color = secondaryColor;
    canvas.drawCircle(const Offset(-30, 0), 10, paint);

    canvas.restore();
  }

  void _drawNormalArm(Canvas canvas, Offset center, Paint paint, bool isLeft) {
    canvas.save();

    if (isLeft) {
      canvas.translate(center.dx - 50, center.dy + 5);
      canvas.scale(-1, 1);
    } else {
      canvas.translate(center.dx + 50, center.dy + 5);
    }

    paint.color = primaryColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-8, -5, 30, 12),
        const Radius.circular(6),
      ),
      paint,
    );

    paint.color = secondaryColor;
    canvas.drawCircle(const Offset(25, 0), 9, paint);

    canvas.restore();
  }

  void _drawLegs(Canvas canvas, Offset center, Paint paint) {
    paint.color = primaryColor;

    // Left leg
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx - 20, center.dy + 70),
          width: 15,
          height: 30,
        ),
        const Radius.circular(8),
      ),
      paint,
    );

    // Right leg
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx + 20, center.dy + 70),
          width: 15,
          height: 30,
        ),
        const Radius.circular(8),
      ),
      paint,
    );

    // Feet
    paint.color = secondaryColor;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx - 20, center.dy + 90),
          width: 20,
          height: 10,
        ),
        const Radius.circular(5),
      ),
      paint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx + 20, center.dy + 90),
          width: 20,
          height: 10,
        ),
        const Radius.circular(5),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(_RobotPainter oldDelegate) {
    return oldDelegate.gestureProgress != gestureProgress ||
        oldDelegate.blinkValue != blinkValue ||
        oldDelegate.gesture != gesture;
  }
}