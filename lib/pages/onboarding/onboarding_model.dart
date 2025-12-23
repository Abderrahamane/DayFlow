// lib/pages/onboarding/onboarding_model.dart (LOCALIZED)
import 'package:flutter/material.dart';
import 'package:dayflow/utils/onboarding_localizations.dart';

class OnboardingSlide {
  final String Function(BuildContext) title;
  final String Function(BuildContext) description;
  final IconData icon;
  final Color color;
  final List<IconData> decorativeIcons;

  OnboardingSlide({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.decorativeIcons = const [],
  });
}

class OnboardingData {
  static List<OnboardingSlide> getSlides() {
    return [
      OnboardingSlide(
        title: (context) => OnboardingLocalizations.of(context).organizeYourTasks,
        description: (context) => OnboardingLocalizations.of(context).organizeTasksDesc,
        icon: Icons.check_circle,
        color: const Color(0xFF6366F1), // Indigo
        decorativeIcons: [
          Icons.task_alt,
          Icons.playlist_add_check,
          Icons.assignment_turned_in,
        ],
      ),
      OnboardingSlide(
        title: (context) => OnboardingLocalizations.of(context).captureYourIdeas,
        description: (context) => OnboardingLocalizations.of(context).captureIdeasDesc,
        icon: Icons.note_outlined,
        color: const Color(0xFF8B5CF6), // Purple
        decorativeIcons: [
          Icons.edit_note,
          Icons.sticky_note_2,
          Icons.description,
        ],
      ),
      OnboardingSlide(
        title: (context) => OnboardingLocalizations.of(context).setSmartReminders,
        description: (context) => OnboardingLocalizations.of(context).setRemindersDesc,
        icon: Icons.alarm,
        color: const Color(0xFF06B6D4), // Cyan
        decorativeIcons: [
          Icons.alarm_add,
          Icons.notifications_active,
          Icons.schedule,
        ],
      ),
      OnboardingSlide(
        title: (context) => OnboardingLocalizations.of(context).trackYourHabits,
        description: (context) => OnboardingLocalizations.of(context).trackHabitsDesc,
        icon: Icons.track_changes,
        color: const Color(0xFF10B981), // Green
        decorativeIcons: [
          Icons.trending_up,
          Icons.emoji_events,
          Icons.stars,
        ],
      ),
    ];
  }
}