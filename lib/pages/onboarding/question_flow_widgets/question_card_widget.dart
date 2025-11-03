// lib/pages/onboarding/question_flow_widgets/question_card_widget.dart

import 'package:flutter/material.dart';

class QuestionCardWidget extends StatelessWidget {
  final List<String> answers;
  final String? selectedAnswer;
  final Function(String) onAnswerSelected;
  final bool isTransitioning;

  const QuestionCardWidget({
    super.key,
    required this.answers,
    required this.selectedAnswer,
    required this.onAnswerSelected,
    required this.isTransitioning,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: answers.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _AnswerCard(
            text: answers[index],
            isSelected: selectedAnswer == answers[index],
            onTap: () => onAnswerSelected(answers[index]),
            delay: index * 100,
            isDisabled: isTransitioning,
          ),
        );
      },
    );
  }
}

class _AnswerCard extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final int delay;
  final bool isDisabled;

  const _AnswerCard({
    required this.text,
    required this.isSelected,
    required this.onTap,
    required this.delay,
    required this.isDisabled,
  });

  @override
  State<_AnswerCard> createState() => _AnswerCardState();
}

class _AnswerCardState extends State<_AnswerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    // Staggered entrance animation
    Future.delayed(Duration(milliseconds: widget.delay + 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.isDisabled) return;

    setState(() => _isPressed = true);

    // Bounce animation
    _controller.reverse().then((_) {
      if (mounted) {
        _controller.forward().then((_) {
          widget.onTap();
          setState(() => _isPressed = false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: GestureDetector(
            onTapDown: (_) {
              if (!widget.isDisabled) {
                setState(() => _isPressed = true);
              }
            },
            onTapUp: (_) {
              if (!widget.isDisabled) {
                setState(() => _isPressed = false);
              }
            },
            onTapCancel: () {
              if (!widget.isDisabled) {
                setState(() => _isPressed = false);
              }
            },
            onTap: _handleTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              transform: Matrix4.identity()
                ..scale(_isPressed ? 0.96 : 1.0),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? theme.colorScheme.primary
                    : isDark
                    ? const Color(0xFF1E293B)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.isSelected
                      ? theme.colorScheme.primary
                      : isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.isSelected
                        ? theme.colorScheme.primary.withOpacity(0.3)
                        : Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                    blurRadius: widget.isSelected ? 16 : 8,
                    offset: Offset(0, widget.isSelected ? 6 : 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.text,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: widget.isSelected
                              ? Colors.white
                              : isDark
                              ? Colors.white
                              : const Color(0xFF1E293B),
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.isSelected
                            ? Colors.white
                            : isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
                      child: widget.isSelected
                          ? Icon(
                        Icons.check,
                        size: 18,
                        color: theme.colorScheme.primary,
                      )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}