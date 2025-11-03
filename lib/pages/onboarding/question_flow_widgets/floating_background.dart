// lib/pages/onboarding/question_flow_widgets/floating_background.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;

class FloatingBackground extends StatefulWidget {
  const FloatingBackground({super.key});

  @override
  State<FloatingBackground> createState() => _FloatingBackgroundState();
}

class _FloatingBackgroundState extends State<FloatingBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                    const Color(0xFF0F172A),
                    const Color(0xFF1E293B),
                  ]
                      : [
                    const Color(0xFFF8FAFC),
                    const Color(0xFFE2E8F0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // Floating shapes
            ..._buildFloatingShapes(context, theme, isDark),
          ],
        );
      },
    );
  }

  List<Widget> _buildFloatingShapes(
      BuildContext context,
      ThemeData theme,
      bool isDark,
      ) {
    final shapes = <Widget>[];
    final screenSize = MediaQuery.of(context).size;

    for (int i = 0; i < 8; i++) {
      final random = math.Random(i);
      final startX = random.nextDouble();
      final startY = random.nextDouble();
      final speed = 0.3 + random.nextDouble() * 0.4;
      final size = 60.0 + random.nextDouble() * 100;
      final opacity = 0.03 + random.nextDouble() * 0.05;

      final progress = (_controller.value * speed + i * 0.125) % 1.0;

      final x = screenSize.width * ((startX + progress * 0.3) % 1.0);
      final y = screenSize.height * ((startY + math.sin(progress * math.pi * 2) * 0.2) % 1.0);

      final isCircle = random.nextBool();
      final color = i % 2 == 0
          ? theme.colorScheme.primary
          : theme.colorScheme.secondary;

      shapes.add(
        Positioned(
          left: x - size / 2,
          top: y - size / 2,
          child: Transform.rotate(
            angle: progress * math.pi * 2,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color.withOpacity(opacity),
                shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: isCircle ? null : BorderRadius.circular(size * 0.2),
              ),
            ),
          ),
        ),
      );
    }

    return shapes;
  }
}