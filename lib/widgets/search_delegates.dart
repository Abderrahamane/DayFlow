import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task/task_bloc.dart';
import '../blocs/habit/habit_bloc.dart';
import '../models/task_model.dart';
import '../models/habit_model.dart';
import 'task_card.dart';
import 'habit_card.dart';
import '../utils/date_utils.dart';

class TaskSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            context.read<TaskBloc>().add(const SearchTasks(''));
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
        context.read<TaskBloc>().add(const SearchTasks(''));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    context.read<TaskBloc>().add(SearchTasks(query));
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    context.read<TaskBloc>().add(SearchTasks(query));
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        final tasks = state.visibleTasks;
        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No tasks found for "$query"',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TaskCard(
                task: task,
                onTap: () {
                  // Ideally open task details
                },
                onToggleComplete: () => context
                    .read<TaskBloc>()
                    .add(ToggleTaskCompletionEvent(task.id)),
                onDelete: () => context
                    .read<TaskBloc>()
                    .add(DeleteTaskEvent(task.id)),
              ),
            );
          },
        );
      },
    );
  }
}

class HabitSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            context.read<HabitBloc>().add(const SearchHabits(''));
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
        context.read<HabitBloc>().add(const SearchHabits(''));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    context.read<HabitBloc>().add(SearchHabits(query));
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    context.read<HabitBloc>().add(SearchHabits(query));
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    return BlocBuilder<HabitBloc, HabitState>(
      builder: (context, state) {
        final habits = state.visibleHabits;
        if (habits.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No habits found for "$query"',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: habits.length,
          itemBuilder: (context, index) {
            final habit = habits[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: HabitCard(
                habit: habit,
                onTap: () {
                  // Open habit details
                },
                onToggleComplete: () {
                  final today = getDateKey(DateTime.now());
                  context.read<HabitBloc>().add(
                    ToggleHabitCompletionEvent(
                      habitId: habit.id,
                      dateKey: today,
                    ),
                  );
                },
                onDelete: () => context
                    .read<HabitBloc>()
                    .add(DeleteHabitEvent(habit.id)),
              ),
            );
          },
        );
      },
    );
  }

  String getDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}

class SettingsSearchDelegate extends SearchDelegate {
  final List<String> settings = [
    'Theme',
    'Language',
    'Notifications',
    'Account',
    'Privacy',
    'Help & Support',
    'About',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final results = settings
        .where((s) => s.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No settings found for "$query"',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final setting = results[index];
        return ListTile(
          title: Text(setting),
          leading: const Icon(Icons.settings),
          onTap: () {
            // Navigate to setting?
            // For now just close
            close(context, null);
          },
        );
      },
    );
  }
}

