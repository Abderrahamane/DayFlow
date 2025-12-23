// lib/widgets/bottom_nav_bar.dart (WITH LOCALIZATION)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dayflow/utils/navigation_localizations.dart';
import '../blocs/navigation/navigation_cubit.dart';
import '../pages/todo_page.dart';
import '../pages/notes_page.dart';
import '../pages/settings_page.dart';
import '../pages/calendar_page.dart';
import 'app_drawer.dart';
import '../pages/habits_page.dart';
import 'search_delegates.dart';
import '../pages/notifications_page.dart';

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
    final navL10n = NavigationLocalizations.of(context);
    switch (index) {
      case 0:
        return navL10n.tasks;
      case 1:
        return navL10n.notes;
      case 2:
        return navL10n.calendar;
      case 3:
        return navL10n.habits;
      case 4:
        return navL10n.settings;
      default:
        return navL10n.tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    final navL10n = NavigationLocalizations.of(context);
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
                tooltip: navL10n.openMenu,
              ),
              actions: [
                if (currentIndex != 4)
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      if (currentIndex == 0) {
                        showSearch(context: context, delegate: TaskSearchDelegate());
                      } else if (currentIndex == 3) {
                        showSearch(context: context, delegate: HabitSearchDelegate());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(navL10n.comingSoon),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    tooltip: navL10n.search,
                  ),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationsPage()),
                    );
                  },
                  tooltip: navL10n.notifications,
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
            label: navL10n.tasks,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.note_outlined),
            activeIcon: const Icon(Icons.note),
            label: navL10n.notes,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today_outlined),
            activeIcon: const Icon(Icons.calendar_today),
            label: navL10n.calendar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.track_changes_outlined),
            activeIcon: const Icon(Icons.track_changes),
            label: navL10n.habits,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: navL10n.settings,
          ),
        ],
      ),
    );
  }
}