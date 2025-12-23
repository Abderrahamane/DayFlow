// lib/pages/onboarding/question_flow_widgets/progress_dots_widget.dart

import 'package:flutter/material.dart';

class ProgressDotsWidget extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;

  const ProgressDotsWidget({
    super.key,
    required this.currentIndex,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalQuestions, (index) {
        final isActive = index == currentIndex;
        final isPassed = index < currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isPassed || isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: isPassed
              ? Center(
            child: Icon(
              Icons.check,
              size: 6,
              color: Colors.white,
            ),
          )
              : null,
        );
      }),
    );
  }
}