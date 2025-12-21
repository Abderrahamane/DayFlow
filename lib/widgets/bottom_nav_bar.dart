// lib/widgets/bottom_nav_bar.dart (WITH LOCALIZATION)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dayflow/utils/app_localizations.dart';
import '../blocs/navigation/navigation_cubit.dart';
import '../pages/todo_page.dart';
import '../pages/notes_page.dart';
import '../pages/settings_page.dart';
import '../pages/calendar_page.dart';
import 'app_drawer.dart';
import '../pages/habits_page.dart';
import 'search_delegates.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Pages corresponding to bottom nav items
  final List<Widget> _pages = [
    const TodoPage(),
    const NotesPage(),
    const CalendarPage(),
    const HabitsPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    context.read<NavigationCubit>().setIndex(index);
  }

  // Get page title based on current index - localized
  String _getPageTitle(BuildContext context, int index) {
    final l10n = AppLocalizations.of(context);
    switch (index) {
      case 0:
        return l10n.tasks;
      case 1:
        return l10n.notes;
      case 2:
        return 'Calendar';
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
    final navigationState = context.watch<NavigationCubit>().state;
    final currentIndex = navigationState.index;

    // Hide AppBar for Notes (1) and Calendar (2) pages as they have their own
    final bool showAppBar = currentIndex != 1 && currentIndex != 2;

    return Scaffold(
      key: _scaffoldKey,
      appBar: showAppBar
          ? AppBar(
              title: Text(_getPageTitle(context, currentIndex)),
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
                    if (currentIndex == 0) {
                      showSearch(context: context, delegate: TaskSearchDelegate());
                    } else if (currentIndex == 3) {
                      showSearch(context: context, delegate: HabitSearchDelegate());
                    } else if (currentIndex == 4) {
                      showSearch(context: context, delegate: SettingsSearchDelegate());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.comingSoon),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
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
            )
          : null,
      drawer: const AppDrawer(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
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
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Calendar',
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