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

class Routes {
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String todo = '/todo';
  static const String notes = '/notes';
  static const String reminders = '/reminders';
  static const String habits = '/habits';
  static const String settings = '/settings';
  static const String login = '/login';
  static const String signup = '/signup';

  static Map<String, WidgetBuilder> routes = {
    welcome: (context) => const WelcomePage(),
    home: (context) => const MainNavigationShell(),
    todo: (context) => const TodoPage(),
    reminders: (context) => const RemindersPage(),
    habits: (context) => const HabitsPage(),
    settings: (context) => const SettingsPage(),
    login: (context) => const LoginPage(),
    signup: (context) => const SignupPage(),
  };

  static void navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, home);
  }

  static void navigateToWelcome(BuildContext context) {
    print('Navigating to: ${Routes.welcome}');
    Navigator.pushReplacementNamed(context, welcome);
  }

  static void navigateToLogin(BuildContext context) {
    Navigator.pushNamed(context, login);
  }

  static void navigateToSignup(BuildContext context) {
    Navigator.pushNamed(context, signup);
  }
}