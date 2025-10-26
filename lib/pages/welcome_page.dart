import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'onboarding/onboarding_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _contentController;
  late AnimationController _buttonController;

  late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleOpacity;
  late Animation<double> _taglineOpacity;
  late Animation<double> _featuresOpacity;
  late Animation<Offset> _buttonSlide;
  late Animation<double> _buttonOpacity;

  @override
  void initState() {
    super.initState();

    // Gradient animation controller (continuous)
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Content animation controller
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Button animation controller (delayed)
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Logo animations (0-400ms)
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
      ),
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.3, curve: Curves.elasticOut),
      ),
    );

    // Title animations (200-600ms)
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.1, 0.3, curve: Curves.easeOut),
      ),
    );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.1, 0.3, curve: Curves.easeIn),
      ),
    );

    // Tagline animation (400-800ms)
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.2, 0.4, curve: Curves.easeIn),
      ),
    );

    // Features animation (600-1200ms)
    _featuresOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeIn),
      ),
    );

    // Button animations
    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Curves.easeOut,
      ),
    );

    _buttonOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Curves.easeIn,
      ),
    );

    // Start animations
    _contentController.forward();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _buttonController.forward();
    });
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _contentController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.primary,
                ],
                begin: Alignment(
                  math.cos(_gradientController.value * 2 * math.pi) * 0.5,
                  math.sin(_gradientController.value * 2 * math.pi) * 0.5,
                ),
                end: Alignment(
                  -math.cos(_gradientController.value * 2 * math.pi) * 0.5,
                  -math.sin(_gradientController.value * 2 * math.pi) * 0.5,
                ),
              ),
            ),
            child: Stack(
              children: [
                // Animated background shapes
                ..._buildBackgroundShapes(),

                // Main content
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: child!,
                  ),
                ),
              ],
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Animated Logo
            AnimatedBuilder(
              animation: _contentController,
              builder: (context, child) {
                return Opacity(
                  opacity: _logoOpacity.value,
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: child,
                  ),
                );
              },
              child: _AnimatedLogo(),
            ),

            const SizedBox(height: 32),

            // Animated App Name
            SlideTransition(
              position: _titleSlide,
              child: FadeTransition(
                opacity: _titleOpacity,
                child: const Text(
                  'DayFlow',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Animated Tagline
            FadeTransition(
              opacity: _taglineOpacity,
              child: Text(
                'Your Smart Daily Planner',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),

            const SizedBox(height: 48),

            // Animated Features List
            FadeTransition(
              opacity: _featuresOpacity,
              child: Column(
                children: [
                  _AnimatedFeatureItem(
                    icon: Icons.check_circle_outline,
                    text: 'Organize your tasks efficiently',
                    delay: 0,
                  ),
                  const SizedBox(height: 16),
                  _AnimatedFeatureItem(
                    icon: Icons.note_outlined,
                    text: 'Capture ideas instantly',
                    delay: 100,
                  ),
                  const SizedBox(height: 16),
                  _AnimatedFeatureItem(
                    icon: Icons.alarm_outlined,
                    text: 'Never miss important reminders',
                    delay: 200,
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Animated Get Started Button
            SlideTransition(
              position: _buttonSlide,
              child: FadeTransition(
                opacity: _buttonOpacity,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: _PulsingButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OnboardingPage(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Animated Sign In Link
            FadeTransition(
              opacity: _buttonOpacity,
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sign in coming soon!')),
                  );
                },
                child: const Text(
                  'Already have an account? Sign In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBackgroundShapes() {
    return List.generate(5, (index) {
      return AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          final progress = (_gradientController.value + index * 0.2) % 1.0;
          return Positioned(
            left: MediaQuery.of(context).size.width * progress - 50,
            top: 50.0 + index * 150.0,
            child: Opacity(
              opacity: 0.1,
              child: Transform.rotate(
                angle: progress * 2 * math.pi,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

// Animated Logo Widget
class _AnimatedLogo extends StatefulWidget {
  @override
  State<_AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<_AnimatedLogo> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 20 * _pulseAnimation.value,
                  spreadRadius: 5 * _pulseAnimation.value,
                ),
              ],
            ),
            child: const Icon(
              Icons.water_drop_rounded,
              size: 64,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

// Animated Feature Item
class _AnimatedFeatureItem extends StatefulWidget {
  final IconData icon;
  final String text;
  final int delay;

  const _AnimatedFeatureItem({
    required this.icon,
    required this.text,
    required this.delay,
  });

  @override
  State<_AnimatedFeatureItem> createState() => _AnimatedFeatureItemState();
}

class _AnimatedFeatureItemState extends State<_AnimatedFeatureItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    Future.delayed(Duration(milliseconds: 600 + widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pulsing Button Widget
class _PulsingButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _PulsingButton({required this.onPressed});

  @override
  State<_PulsingButton> createState() => _PulsingButtonState();
}

class _PulsingButtonState extends State<_PulsingButton> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isPressed ? 0.95 : _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            child: ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: _isPressed ? 2 : 8,
                shadowColor: Colors.black.withOpacity(0.3),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}