import 'package:flutter/material.dart';

class OnboardingSlide {
  final String title;
  final String description;
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
        title: 'Organize Your Tasks',
        description:
        'Create, manage, and prioritize your daily tasks with ease. Never miss a deadline again.',
        icon: Icons.check_circle,
        color: const Color(0xFF6366F1), // Indigo
        decorativeIcons: [
          Icons.task_alt,
          Icons.playlist_add_check,
          Icons.assignment_turned_in,
        ],
      ),
      OnboardingSlide(
        title: 'Capture Your Ideas',
        description:
        'Jot down notes, thoughts, and ideas instantly. Keep everything organized in one place.',
        icon: Icons.note_outlined,
        color: const Color(0xFF8B5CF6), // Purple
        decorativeIcons: [
          Icons.edit_note,
          Icons.sticky_note_2,
          Icons.description,
        ],
      ),
      OnboardingSlide(
        title: 'Set Smart Reminders',
        description:
        'Get timely notifications for important tasks. Stay on top of your schedule effortlessly.',
        icon: Icons.alarm,
        color: const Color(0xFF06B6D4), // Cyan
        decorativeIcons: [
          Icons.alarm_add,
          Icons.notifications_active,
          Icons.schedule,
        ],
      ),
      OnboardingSlide(
        title: 'Track Your Habits',
        description:
        'Build better habits with daily tracking. Monitor your progress and achieve your goals.',
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