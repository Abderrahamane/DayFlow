// lib/utils/routes.dart (UPDATED)
import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../pages/welcome_page.dart';
import '../pages/todo_page.dart';
import '../pages/reminders_page.dart';
import '../pages/habits_page.dart';
import '../pages/settings_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/signup_page.dart';
import '../pages/auth/forgot_password_page.dart';
import '../pages/auth/email_verification_page.dart';
import '../pages/privacy_backup_page.dart';
import '../pages/help_support_page.dart';
import '../pages/terms_privacy_page.dart';
import '../pages/calendar_page.dart';
import '../pages/habit_stats_page.dart';
import '../pages/templates_page.dart';
import '../pages/pomodoro_page.dart';

class Routes {
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String todo = '/todo';
  static const String notes = '/notes';
  static const String reminders = '/reminders';
  static const String habits = '/habits';
  static const String settings = '/settings';
  static const String calendar = '/calendar';
  static const String habitStats = '/habit-stats';
  static const String templates = '/templates';
  static const String pomodoro = '/pomodoro';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String emailVerification = '/email-verification';
  static const String privacyBackup = '/privacy-backup';
  static const String helpSupport = '/help-support';
  static const String termsPrivacy = '/terms-privacy';

  static Map<String, WidgetBuilder> routes = {
    welcome: (context) => const WelcomePage(),
    home: (context) => const MainNavigationShell(),
    todo: (context) => const TodoPage(),
    reminders: (context) => const RemindersPage(),
    habits: (context) => const HabitsPage(),
    settings: (context) => const SettingsPage(),
    calendar: (context) => const CalendarPage(),
    habitStats: (context) => const HabitStatsPage(),
    templates: (context) => const TemplatesPage(),
    pomodoro: (context) => const PomodoroPage(),
    login: (context) => const LoginPage(),
    signup: (context) => const SignupPage(),
    forgotPassword: (context) => const ForgotPasswordPage(),
    emailVerification: (context) => const EmailVerificationPage(),
    privacyBackup: (context) => const PrivacyBackupPage(),
    helpSupport: (context) => const HelpSupportPage(),
    termsPrivacy: (context) => const TermsPrivacyPage(),
  };

  static void navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, home);
  }

  static void navigateToWelcome(BuildContext context) {
    print('Navigating to: $welcome');
    Navigator.pushReplacementNamed(context, welcome);
  }

  static void navigateToLogin(BuildContext context) {
    Navigator.pushNamed(context, login);
  }

  static void navigateToSignup(BuildContext context) {
    Navigator.pushNamed(context, signup);
  }

  static void navigateToForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, forgotPassword);
  }

  static void navigateToEmailVerification(BuildContext context) {
    Navigator.pushReplacementNamed(context, emailVerification);
  }

  static void navigateToPrivacyBackup(BuildContext context) {
    Navigator.pushNamed(context, privacyBackup);
  }

  static void navigateToHelpSupport(BuildContext context) {
    Navigator.pushNamed(context, helpSupport);
  }

  static void navigateToTermsPrivacy(BuildContext context) {
    Navigator.pushNamed(context, termsPrivacy);
  }

  static void navigateToCalendar(BuildContext context) {
    Navigator.pushNamed(context, calendar);
  }

  static void navigateToHabitStats(BuildContext context) {
    Navigator.pushNamed(context, habitStats);
  }

  static void navigateToTemplates(BuildContext context) {
    Navigator.pushNamed(context, templates);
  }

  static void navigateToPomodoro(BuildContext context) {
    Navigator.pushNamed(context, pomodoro);
  }
}