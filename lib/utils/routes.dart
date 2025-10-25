import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../pages/welcome_page.dart';
import '../pages/todo_page.dart';
import '../pages/reminders_page.dart';
import '../pages/habits_page.dart';
import '../pages/settings_page.dart';



class Routes {
  static const String welcome = '/';
  static const String home = '/home';
  static const String todo = '/todo';
  static const String notes = '/notes';
  static const String reminders = '/reminders';
  static const String habits = '/habits';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> routes = {
    welcome: (context) => const WelcomePage(),
    home: (context) => const MainNavigationShell(),
    todo: (context) => const TodoPage(),
    reminders: (context) => const RemindersPage(),
    habits: (context) => const HabitsPage(),
    settings: (context) => const SettingsPage(),

  };

  static void navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, home);
  }

  static void navigateToWelcome(BuildContext context) {
    Navigator.pushReplacementNamed(context, welcome);
  }
}