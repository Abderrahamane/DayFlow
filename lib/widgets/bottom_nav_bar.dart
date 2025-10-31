// lib/widgets/bottom_nav_bar.dart (WITH LOCALIZATION)
import 'package:flutter/material.dart';
import 'package:dayflow/utils/app_localizations.dart';
import '../pages/todo_page.dart';
import '../pages/notes_page.dart';
import '../pages/reminders_page.dart';
import '../pages/settings_page.dart';
import 'app_drawer.dart';
import '../pages/habits_page.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Pages corresponding to bottom nav items
  final List<Widget> _pages = [
    const TodoPage(),
    const NotesPage(),
    const RemindersPage(),
    const HabitsPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Get page title based on current index - localized
  String _getPageTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (_currentIndex) {
      case 0:
        return l10n.tasks;
      case 1:
        return l10n.notes;
      case 2:
        return l10n.reminders;
      case 3:
        return l10n.habits;
      case 4:
        return l10n.settings;
      default:
        return l10n.tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_getPageTitle(context)),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          tooltip: l10n.openMenu,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.comingSoon),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: l10n.search,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.noNotifications),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: l10n.notifications,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.check_circle_outline),
            activeIcon: const Icon(Icons.check_circle),
            label: l10n.tasks,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.note_outlined),
            activeIcon: const Icon(Icons.note),
            label: l10n.notes,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.alarm_outlined),
            activeIcon: const Icon(Icons.alarm),
            label: l10n.reminders,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.track_changes_outlined),
            activeIcon: const Icon(Icons.track_changes),
            label: l10n.habits,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}