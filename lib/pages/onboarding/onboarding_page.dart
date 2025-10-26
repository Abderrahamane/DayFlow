import 'package:flutter/material.dart';
import '../../utils/routes.dart';
import 'onboarding_model.dart';
import 'onboarding_slide_widget.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<OnboardingSlide> _slides = OnboardingData.getSlides();
  late AnimationController _buttonAnimationController;

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _buttonAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    // Reset and replay button animation
    _buttonAnimationController.reset();
    _buttonAnimationController.forward();
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    Routes.navigateToHome(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView with slides
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              return OnboardingSlideWidget(
                slide: _slides[index],
                isActive: index == _currentPage,
              );
            },
          ),

          // Top Skip Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: _currentPage < _slides.length - 1
                    ? _AnimatedSkipButton(
                  onPressed: _skipOnboarding,
                  controller: _buttonAnimationController,
                )
                    : const SizedBox.shrink(),
              ),
            ),
          ),

          // Bottom Navigation Controls
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Page Indicators
                  _PageIndicators(
                    currentPage: _currentPage,
                    totalPages: _slides.length,
                  ),

                  const SizedBox(height: 32),

                  // Navigation Button
                  _AnimatedNavigationButton(
                    isLastPage: _currentPage == _slides.length - 1,
                    onPressed: _nextPage,
                    color: _slides[_currentPage].color,
                    controller: _buttonAnimationController,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Animated Skip Button
class _AnimatedSkipButton extends StatelessWidget {
  final VoidCallback onPressed;
  final AnimationController controller;

  const _AnimatedSkipButton({
    required this.onPressed,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: controller,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.5, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: Curves.easeOut,
        )),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
            child: const Text(
              'Skip',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Page Indicators with animation
class _PageIndicators extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const _PageIndicators({
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentPage == index ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: currentPage == index
                ? Colors.white
                : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(4),
            boxShadow: currentPage == index
                ? [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ]
                : null,
          ),
        ),
      ),
    );
  }
}

// Animated Navigation Button
class _AnimatedNavigationButton extends StatefulWidget {
  final bool isLastPage;
  final VoidCallback onPressed;
  final Color color;
  final AnimationController controller;

  const _AnimatedNavigationButton({
    required this.isLastPage,
    required this.onPressed,
    required this.color,
    required this.controller,
  });

  @override
  State<_AnimatedNavigationButton> createState() =>
      _AnimatedNavigationButtonState();
}

class _AnimatedNavigationButtonState extends State<_AnimatedNavigationButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
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
      animation: Listenable.merge([widget.controller, _pulseAnimation]),
      builder: (context, child) {
        return FadeTransition(
          opacity: widget.controller,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.5),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: widget.controller,
              curve: Curves.easeOut,
            )),
            child: Transform.scale(
              scale: _pulseAnimation.value,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: widget.onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: widget.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.isLastPage ? 'Get Started' : 'Next',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        widget.isLastPage ? Icons.check : Icons.arrow_forward,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}