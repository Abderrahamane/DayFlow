// lib/pages/onboarding/onboarding_slide_widget.dart (LOCALIZED)

import 'package:flutter/material.dart';
import 'onboarding_model.dart';

class OnboardingSlideWidget extends StatefulWidget {
  final OnboardingSlide slide;
  final bool isActive;

  const OnboardingSlideWidget({
    super.key,
    required this.slide,
    required this.isActive,
  });

  @override
  State<OnboardingSlideWidget> createState() => _OnboardingSlideWidgetState();
}

class _OnboardingSlideWidgetState extends State<OnboardingSlideWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _iconRotationAnimation;
  late Animation<double> _contentOpacityAnimation;
  late Animation<Offset> _contentSlideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _iconScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _iconRotationAnimation = Tween<double>(begin: -0.2, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _contentOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );

    _contentSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    if (widget.isActive) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(OnboardingSlideWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.slide.color,
            widget.slide.color.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              SizedBox(
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ...List.generate(
                      widget.slide.decorativeIcons.length,
                          (index) => _FloatingIcon(
                        icon: widget.slide.decorativeIcons[index],
                        controller: _controller,
                        index: index,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _iconScaleAnimation.value,
                    child: Transform.rotate(
                      angle: _iconRotationAnimation.value,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(35),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.slide.icon,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 60),

              SlideTransition(
                position: _contentSlideAnimation,
                child: FadeTransition(
                  opacity: _contentOpacityAnimation,
                  child: Column(
                    children: [
                      Text(
                        widget.slide.title(context),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      Text(
                        widget.slide.description(context),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingIcon extends StatelessWidget {
  final IconData icon;
  final AnimationController controller;
  final int index;

  const _FloatingIcon({
    required this.icon,
    required this.controller,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final positions = [
      const Offset(-80, -30),
      const Offset(80, -20),
      const Offset(0, 40),
    ];

    if (index >= positions.length) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final offset = positions[index];
        final delay = index * 0.1;
        final opacity = Tween<double>(begin: 0.0, end: 0.3).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(delay, 0.5 + delay, curve: Curves.easeIn),
          ),
        );

        final scale = Tween<double>(begin: 0.5, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(delay, 0.5 + delay, curve: Curves.easeOut),
          ),
        );

        return Positioned(
          left: MediaQuery.of(context).size.width / 2 + offset.dx - 16,
          top: offset.dy + 20,
          child: Opacity(
            opacity: opacity.value,
            child: Transform.scale(
              scale: scale.value,
              child: Icon(
                icon,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}