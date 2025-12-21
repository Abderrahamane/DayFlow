import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../blocs/calendar/calendar_bloc.dart';
import '../blocs/task/task_bloc.dart';
import '../blocs/navigation/navigation_cubit.dart';
import '../models/task_model.dart';
import '../models/habit_model.dart';
import '../theme/app_theme.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> with TickerProviderStateMixin {
  late TabController _tabController;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<CalendarBloc>().add(LoadCalendarData());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return AppTheme.errorColor;
      case TaskPriority.medium:
        return const Color(0xFFF59E0B);
      case TaskPriority.low:
        return AppTheme.successColor;
      case TaskPriority.none:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: 'Open Menu',
        ),
        title: const Text('Calendar'),
        centerTitle: true,
        actions: [
          PopupMenuButton<CalendarFormat>(
            icon: const Icon(Icons.calendar_view_month),
            onSelected: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: CalendarFormat.month,
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_view_month,
                      color: _calendarFormat == CalendarFormat.month
                          ? theme.colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 12),
                    const Text('Month View'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: CalendarFormat.twoWeeks,
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_view_week,
                      color: _calendarFormat == CalendarFormat.twoWeeks
                          ? theme.colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 12),
                    const Text('Two Weeks'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: CalendarFormat.week,
                child: Row(
                  children: [
                    Icon(
                      Icons.view_week,
                      color: _calendarFormat == CalendarFormat.week
                          ? theme.colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 12),
                    const Text('Week View'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          if (state.status == CalendarStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == CalendarStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.error.withValues(alpha: 0.7),
                  ),
                  const SizedBox(height: 16),
                  Text('Failed to load calendar', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => context.read<CalendarBloc>().add(LoadCalendarData()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Calendar widget
              _buildCalendar(state, theme),

              // Divider
              Container(
                height: 1,
                color: theme.dividerColor.withValues(alpha: 0.3),
              ),

              // Tab bar for tasks and habits
              Container(
                color: theme.colorScheme.surface,
                child: TabBar(
                  controller: _tabController,
                  labelColor: theme.colorScheme.primary,
                  unselectedLabelColor: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                  indicatorColor: theme.colorScheme.primary,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.task_alt, size: 18),
                          const SizedBox(width: 6),
                          Text('Tasks (${state.selectedDateTasks.length})'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.track_changes, size: 18),
                          const SizedBox(width: 6),
                          Text('Habits (${state.selectedDateHabits.length})'),
                        ],
                      ),
                    ),
                    const Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.summarize, size: 18),
                          SizedBox(width: 6),
                          Text('Summary'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTasksList(state, theme),
                    _buildHabitsList(state, theme),
                    _buildSummary(state, theme),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCalendar(CalendarState state, ThemeData theme) {
    return TableCalendar<Task>(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: state.focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) => isSameDay(state.selectedDate, day),
      onDaySelected: (selectedDay, focusedDay) {
        context.read<CalendarBloc>().add(SelectDate(selectedDay));
        context.read<CalendarBloc>().add(ChangeFocusedDay(focusedDay));
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onPageChanged: (focusedDay) {
        context.read<CalendarBloc>().add(ChangeFocusedDay(focusedDay));
      },
      eventLoader: (day) => state.getTasksForDate(day),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendTextStyle: TextStyle(color: theme.colorScheme.primary),
        todayDecoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
        selectedDecoration: BoxDecoration(
          color: theme.colorScheme.primary,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        markerDecoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          shape: BoxShape.circle,
        ),
        markersMaxCount: 3,
        markerSize: 6,
        markerMargin: const EdgeInsets.symmetric(horizontal: 1),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: theme.colorScheme.primary,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.primary,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: theme.textTheme.labelMedium!.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
        ),
        weekendStyle: theme.textTheme.labelMedium!.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.primary,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isEmpty && state.getHabitsForDate(date).isEmpty) {
            return null;
          }

          final tasks = state.getTasksForDate(date);
          final habits = state.getHabitsForDate(date);
          final priorities = tasks.map((t) => t.priority).toSet().toList();

          return Positioned(
            bottom: 4,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...priorities.take(2).map((priority) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _getPriorityColor(priority),
                        shape: BoxShape.circle,
                      ),
                    )),
                if (habits.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTasksList(CalendarState state, ThemeData theme) {
    final tasks = state.selectedDateTasks;
    final dateStr = DateFormat('EEEE, MMMM d').format(state.selectedDate);

    if (tasks.isEmpty) {
      return _buildEmptyListState(
        theme,
        icon: Icons.task_alt,
        title: 'No tasks for $dateStr',
        subtitle: 'Tap the + button to add a task',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _TaskCalendarItem(
          task: task,
          onToggle: () {
            context.read<TaskBloc>().add(ToggleTaskCompletionEvent(task.id));
            context.read<CalendarBloc>().add(LoadCalendarData());
          },
        );
      },
    );
  }

  Widget _buildHabitsList(CalendarState state, ThemeData theme) {
    final habits = state.selectedDateHabits;
    final dateStr = DateFormat('EEEE, MMMM d').format(state.selectedDate);

    if (habits.isEmpty) {
      return _buildEmptyListState(
        theme,
        icon: Icons.track_changes,
        title: 'No habits for $dateStr',
        subtitle: 'Create habits in the Habits tab',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];
        final isCompleted = state.isHabitCompletedOnDate(habit, state.selectedDate);

        return _HabitCalendarItem(
          habit: habit,
          isCompleted: isCompleted,
          onToggle: () {
            // Toggle habit completion through habit bloc
          },
        );
      },
    );
  }

  Widget _buildSummary(CalendarState state, ThemeData theme) {
    final tasks = state.selectedDateTasks;
    final habits = state.selectedDateHabits;
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final completedHabits = habits.where((h) => state.isHabitCompletedOnDate(h, state.selectedDate)).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header
          Text(
            DateFormat('EEEE, MMMM d, yyyy').format(state.selectedDate),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Stats cards
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  icon: Icons.task_alt,
                  title: 'Tasks',
                  value: '$completedTasks/${tasks.length}',
                  color: theme.colorScheme.primary,
                  progress: tasks.isEmpty ? 0 : completedTasks / tasks.length,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SummaryCard(
                  icon: Icons.track_changes,
                  title: 'Habits',
                  value: '$completedHabits/${habits.length}',
                  color: AppTheme.successColor,
                  progress: habits.isEmpty ? 0 : completedHabits / habits.length,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Priority breakdown
          if (tasks.isNotEmpty) ...[
            Text(
              'Tasks by Priority',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildPriorityBreakdown(tasks, theme),
          ],

          if (habits.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Habits Overview',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...habits.map((habit) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _HabitSummaryItem(
                    habit: habit,
                    isCompleted: state.isHabitCompletedOnDate(habit, state.selectedDate),
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildPriorityBreakdown(List<Task> tasks, ThemeData theme) {
    final high = tasks.where((t) => t.priority == TaskPriority.high).length;
    final medium = tasks.where((t) => t.priority == TaskPriority.medium).length;
    final low = tasks.where((t) => t.priority == TaskPriority.low).length;
    final none = tasks.where((t) => t.priority == TaskPriority.none).length;

    return Column(
      children: [
        _PriorityRow(label: 'High', count: high, color: AppTheme.errorColor, total: tasks.length),
        _PriorityRow(label: 'Medium', count: medium, color: const Color(0xFFF59E0B), total: tasks.length),
        _PriorityRow(label: 'Low', count: low, color: AppTheme.successColor, total: tasks.length),
        if (none > 0)
          _PriorityRow(label: 'None', count: none, color: Colors.grey, total: tasks.length),
      ],
    );
  }

  Widget _buildEmptyListState(ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40,
              color: theme.colorScheme.primary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTaskSheet(BuildContext context) {
    // Navigate to task creation with the selected date
    context.read<NavigationCubit>().setIndex(
      0,
      action: NavigationAction.openCreateTask,
      data: context.read<CalendarBloc>().state.selectedDate,
    );
  }
}

class _TaskCalendarItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;

  const _TaskCalendarItem({
    required this.task,
    required this.onToggle,
  });

  Color _getPriorityColor() {
    switch (task.priority) {
      case TaskPriority.high:
        return AppTheme.errorColor;
      case TaskPriority.medium:
        return const Color(0xFFF59E0B);
      case TaskPriority.low:
        return AppTheme.successColor;
      case TaskPriority.none:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: _getPriorityColor(),
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => onToggle(),
          activeColor: _getPriorityColor(),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted
                ? theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5)
                : null,
          ),
        ),
        subtitle: task.description != null
            ? Text(
                task.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getPriorityColor().withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            task.priority.displayName,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _getPriorityColor(),
            ),
          ),
        ),
      ),
    );
  }
}

class _HabitCalendarItem extends StatelessWidget {
  final Habit habit;
  final bool isCompleted;
  final VoidCallback onToggle;

  const _HabitCalendarItem({
    required this.habit,
    required this.isCompleted,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: habit.color,
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: habit.color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              habit.icon,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
        title: Text(habit.name),
        subtitle: Text(
          '${habit.currentStreak} day streak',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
          ),
        ),
        trailing: Icon(
          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isCompleted ? AppTheme.successColor : theme.colorScheme.outline,
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final double progress;

  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriorityRow extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final int total;

  const _PriorityRow({
    required this.label,
    required this.count,
    required this.color,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = total > 0 ? count / total : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: color.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 24,
            child: Text(
              '$count',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitSummaryItem extends StatelessWidget {
  final Habit habit;
  final bool isCompleted;

  const _HabitSummaryItem({
    required this.habit,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted ? AppTheme.successColor : theme.dividerColor.withValues(alpha: 0.3),
          width: isCompleted ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Text(habit.icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${habit.currentStreak} day streak',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isCompleted ? Icons.check_circle : Icons.circle_outlined,
            color: isCompleted ? AppTheme.successColor : theme.colorScheme.outline,
          ),
        ],
      ),
    );
  }
}



