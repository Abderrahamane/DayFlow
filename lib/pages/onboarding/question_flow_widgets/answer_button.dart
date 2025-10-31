// lib/pages/onboarding/question_flow_widgets/answer_button.dart

import 'package:flutter/material.dart';

class AnswerButton extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final int delay;
  final bool isDisabled;

  const AnswerButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    required this.delay,
    required this.isDisabled,
  });

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton>
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
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
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
    widget.onTap();
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
                ..scale(_isPressed ? 0.95 : 1.0),
              decoration: BoxDecoration(
                gradient: widget.isSelected
                    ? LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : null,
                color: widget.isSelected
                    ? null
                    : isDark
                    ? const Color(0xFF1E293B)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.isSelected
                      ? Colors.transparent
                      : isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.isSelected
                        ? theme.colorScheme.primary.withOpacity(0.4)
                        : Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                    blurRadius: widget.isSelected ? 20 : 10,
                    offset: Offset(0, widget.isSelected ? 8 : 4),
                    spreadRadius: widget.isSelected ? 2 : 0,
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
                    // Checkbox indicator
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.isSelected
                            ? Colors.white
                            : isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                        border: Border.all(
                          color: widget.isSelected
                              ? Colors.white
                              : isDark
                              ? const Color(0xFF475569)
                              : const Color(0xFFCBD5E1),
                          width: 2,
                        ),
                      ),
                      child: widget.isSelected
                          ? Icon(
                        Icons.check,
                        size: 18,
                        color: theme.colorScheme.primary,
                      )
                          : null,
                    ),

                    const SizedBox(width: 16),

                    // Answer text
                    Expanded(
                      child: Text(
                        widget.text,
                        style: TextStyle(
                          fontSize: 17,
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

                    // Glow effect when selected
                    if (widget.isSelected)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.6),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
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