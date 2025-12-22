import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../blocs/habit_stats/habit_stats_bloc.dart';
import '../models/habit_model.dart';
import '../theme/app_theme.dart';
import '../utils/habit_localizations.dart';

class HabitStatsPage extends StatefulWidget {
  const HabitStatsPage({super.key});

  @override
  State<HabitStatsPage> createState() => _HabitStatsPageState();
}

class _HabitStatsPageState extends State<HabitStatsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<HabitStatsBloc>().add(LoadHabitStats());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showExportOptions(HabitStatsState state) {
    final habitL10n = HabitLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              habitL10n.exportStatistics,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.text_snippet, color: Theme.of(context).colorScheme.primary),
              ),
              title: Text(habitL10n.exportAsText),
              subtitle: Text(habitL10n.plainTextSummary),
              onTap: () {
                Navigator.pop(ctx);
                _exportAsText(state);
              },
            ),
            ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.share, color: AppTheme.successColor),
              ),
              title: Text(habitL10n.shareStats),
              subtitle: Text(habitL10n.shareWithOthers),
              onTap: () {
                Navigator.pop(ctx);
                _shareStats(state);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _exportAsText(HabitStatsState state) {
    final habitL10n = HabitLocalizations.of(context);
    final buffer = StringBuffer();
    buffer.writeln(habitL10n.habitStatisticsReport);
    buffer.writeln('${habitL10n.generated}${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}');
    buffer.writeln('');
    buffer.writeln('${habitL10n.overview}:');
    buffer.writeln('${habitL10n.totalHabits}${state.habits.length}');
    buffer.writeln('${habitL10n.overallCompletionRate}${state.overallCompletionRate.toStringAsFixed(1)}%');
    buffer.writeln('${habitL10n.totalCompletions}${state.totalCompletionsAllTime}');
    buffer.writeln('${habitL10n.activeStreakDays}${state.totalStreakDays}');
    buffer.writeln('');
    buffer.writeln(habitL10n.individualHabits);
    for (final habit in state.habits) {
      buffer.writeln('');
      buffer.writeln('${habit.icon} ${habit.name}');
      buffer.writeln(habitL10n.currentStreak(habit.currentStreak));
      buffer.writeln(habitL10n.longestStreak(habit.longestStreak));
      buffer.writeln(habitL10n.sevenDayRate(habit.getCompletionRate(7)));
      buffer.writeln(habitL10n.thirtyDayRate(habit.getCompletionRate(30)));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(habitL10n.statsCopied),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  void _shareStats(HabitStatsState state) {
    final habitL10n = HabitLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(habitL10n.shareFunctionality),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final habitL10n = HabitLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(habitL10n.habitStatistics),
        actions: [
          BlocBuilder<HabitStatsBloc, HabitStatsState>(
            builder: (context, state) {
              if (state.habits.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.ios_share),
                  onPressed: () => _showExportOptions(state),
                  tooltip: habitL10n.export,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: habitL10n.overview),
            Tab(text: habitL10n.completionRate),
            Tab(text: habitL10n.streaks),
            Tab(text: habitL10n.heatmap),
          ],
        ),
      ),
      body: BlocBuilder<HabitStatsBloc, HabitStatsState>(
        builder: (context, state) {
          if (state.status == HabitStatsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == HabitStatsStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 64, color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  Text(habitL10n.failedToLoadStats,
                      style: theme.textTheme.titleLarge),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () =>
                        context.read<HabitStatsBloc>().add(LoadHabitStats()),
                    icon: const Icon(Icons.refresh),
                    label: Text(habitL10n.retry),
                  ),
                ],
              ),
            );
          }

          if (state.habits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.track_changes,
                      size: 64, color: theme.colorScheme.primary.withAlpha(128)),
                  const SizedBox(height: 16),
                  Text(habitL10n.noHabitsYet, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(habitL10n.createHabitsToSeeStats,
                      style: theme.textTheme.bodyMedium),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _OverviewTab(state: state),
              _CompletionRateTab(state: state),
              _StreaksTab(state: state),
              _HeatmapTab(state: state),
            ],
          );
        },
      ),
    );
  }
}

// Overview Tab
class _OverviewTab extends StatelessWidget {
  final HabitStatsState state;

  const _OverviewTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time range selector
          _TimeRangeSelector(currentRange: state.timeRange),
          const SizedBox(height: 20),

          // Summary cards
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.percent,
                  title: 'Completion Rate',
                  value: '${state.overallCompletionRate.toStringAsFixed(1)}%',
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.local_fire_department,
                  title: 'Active Streaks',
                  value: '${state.totalStreakDays}',
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.check_circle,
                  title: 'Total Done',
                  value: '${state.totalCompletionsAllTime}',
                  color: AppTheme.successColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.track_changes,
                  title: 'Habits',
                  value: '${state.habits.length}',
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Best performing habit
          if (state.bestPerformingHabit != null) ...[
            Text('Best Performer',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _HabitPerformanceCard(
              habit: state.bestPerformingHabit!,
              rate: state.bestPerformingHabit!
                  .getCompletionRate(state.timeRange.days),
            ),
          ],
          const SizedBox(height: 24),

          // All habits performance
          Text('All Habits Performance',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...state.habits.map((habit) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _HabitPerformanceCard(
                  habit: habit,
                  rate: habit.getCompletionRate(state.timeRange.days),
                ),
              )),
        ],
      ),
    );
  }
}

// Completion Rate Tab with Chart
class _CompletionRateTab extends StatelessWidget {
  final HabitStatsState state;

  const _CompletionRateTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = state.selectedHabitStats;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Habit selector
          _HabitSelector(
            habits: state.habits,
            selectedHabit: state.selectedHabit,
          ),
          const SizedBox(height: 20),

          // Time range selector
          _TimeRangeSelector(currentRange: state.timeRange),
          const SizedBox(height: 20),

          if (stats != null) ...[
            // Completion rate chart
            Text('Completion Rate',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _CompletionRateChart(stats: stats, days: state.timeRange.days),
            ),
            const SizedBox(height: 24),

            // Rate comparison cards
            Row(
              children: [
                Expanded(
                  child: _RateCard(
                    label: '7 Days',
                    rate: stats.completionRate7Days,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _RateCard(
                    label: '30 Days',
                    rate: stats.completionRate30Days,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _RateCard(
                    label: '90 Days',
                    rate: stats.completionRate90Days,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Day of week breakdown
            Text('By Day of Week',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: _DayOfWeekChart(data: stats.completionsByDayOfWeek),
            ),
          ],
        ],
      ),
    );
  }
}

// Streaks Tab
class _StreaksTab extends StatelessWidget {
  final HabitStatsState state;

  const _StreaksTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = state.selectedHabitStats;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Habit selector
          _HabitSelector(
            habits: state.habits,
            selectedHabit: state.selectedHabit,
          ),
          const SizedBox(height: 20),

          if (stats != null) ...[
            // Streak summary
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.local_fire_department,
                    title: 'Current Streak',
                    value: '${stats.currentStreak} days',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.emoji_events,
                    title: 'Longest Streak',
                    value: '${stats.longestStreak} days',
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Streak history chart
            Text('Streak History',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (stats.streakHistory.isNotEmpty)
              SizedBox(
                height: 200,
                child: _StreakHistoryChart(streaks: stats.streakHistory),
              )
            else
              Container(
                height: 120,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'No streak history yet',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withAlpha(128),
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Streak leaderboard
            Text('Streak Leaderboard',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...state.habits
                .toList()
                .sorted((a, b) => b.longestStreak.compareTo(a.longestStreak))
                .take(5)
                .map((habit) => _StreakLeaderboardItem(
                      habit: habit,
                      rank: state.habits
                              .toList()
                              .sorted((a, b) =>
                                  b.longestStreak.compareTo(a.longestStreak))
                              .indexOf(habit) +
                          1,
                    )),
          ],
        ],
      ),
    );
  }
}

// Heatmap Tab (GitHub-style)
class _HeatmapTab extends StatelessWidget {
  final HabitStatsState state;

  const _HeatmapTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = state.selectedHabitStats;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Habit selector
          _HabitSelector(
            habits: state.habits,
            selectedHabit: state.selectedHabit,
          ),
          const SizedBox(height: 20),

          if (stats != null) ...[
            Text('Activity Heatmap',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Last 90 days',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.textTheme.bodyMedium?.color?.withAlpha(128))),
            const SizedBox(height: 16),
            _HeatmapGrid(completionHistory: stats.completionHistory),
            const SizedBox(height: 24),

            // Monthly breakdown
            Text('Monthly Activity',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _MonthlyActivityChart(data: stats.completionsByMonth),
            ),
          ],
        ],
      ),
    );
  }
}

// Reusable Widgets

class _TimeRangeSelector extends StatelessWidget {
  final StatsTimeRange currentRange;

  const _TimeRangeSelector({required this.currentRange});

  String _getLocalizedRangeName(BuildContext context, StatsTimeRange range) {
    final habitL10n = HabitLocalizations.of(context);
    switch (range) {
      case StatsTimeRange.week7:
        return habitL10n.timeRange7Days;
      case StatsTimeRange.month30:
        return habitL10n.timeRange30Days;
      case StatsTimeRange.quarter90:
        return habitL10n.timeRange90Days;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: StatsTimeRange.values.map((range) {
          final isSelected = range == currentRange;
          return Expanded(
            child: GestureDetector(
              onTap: () =>
                  context.read<HabitStatsBloc>().add(ChangeTimeRange(range)),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getLocalizedRangeName(context, range),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : theme.textTheme.bodyMedium?.color,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _HabitSelector extends StatelessWidget {
  final List<Habit> habits;
  final Habit? selectedHabit;

  const _HabitSelector({required this.habits, this.selectedHabit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withAlpha(77)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedHabit?.id,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: habits.map((habit) {
            return DropdownMenuItem(
              value: habit.id,
              child: Row(
                children: [
                  Text(habit.icon, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(habit.name)),
                ],
              ),
            );
          }).toList(),
          onChanged: (id) {
            if (id != null) {
              context.read<HabitStatsBloc>().add(SelectHabit(id));
            }
          },
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
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
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }
}

class _RateCard extends StatelessWidget {
  final String label;
  final double rate;

  const _RateCard({required this.label, required this.rate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = rate >= 70
        ? AppTheme.successColor
        : rate >= 40
            ? Colors.orange
            : AppTheme.errorColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Column(
        children: [
          Text(
            '${rate.toStringAsFixed(0)}%',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _HabitPerformanceCard extends StatelessWidget {
  final Habit habit;
  final double rate;

  const _HabitPerformanceCard({required this.habit, required this.rate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = habit.color;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(habit.icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.local_fire_department,
                        size: 14, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text('${habit.currentStreak} day streak',
                        style: theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${rate.toStringAsFixed(0)}%',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text('completion', style: theme.textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _StreakLeaderboardItem extends StatelessWidget {
  final Habit habit;
  final int rank;

  const _StreakLeaderboardItem({required this.habit, required this.rank});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? [Colors.amber, Colors.grey, Colors.orange][rank - 1]
                      .withAlpha(51)
                  : theme.colorScheme.primary.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: rank <= 3
                      ? [Colors.amber, Colors.grey, Colors.orange][rank - 1]
                      : theme.colorScheme.primary,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(habit.icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(child: Text(habit.name)),
          Text(
            '${habit.longestStreak} days',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Charts

class _CompletionRateChart extends StatelessWidget {
  final HabitStatistics stats;
  final int days;

  const _CompletionRateChart({required this.stats, required this.days});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = stats.getCompletionChartData(days);

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < data.length) {
                  final date = data[value.toInt()].date;
                  if (value.toInt() % (days ~/ 5) == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        DateFormat('d/M').format(date),
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value.completed ? 1 : 0);
            }).toList(),
            isCurved: false,
            color: theme.colorScheme.primary,
            barWidth: 2,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, index) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: spot.y == 1 ? AppTheme.successColor : Colors.grey,
                  strokeWidth: 0,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: theme.colorScheme.primary.withAlpha(26),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayOfWeekChart extends StatelessWidget {
  final Map<int, int> data;

  const _DayOfWeekChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final habitL10n = HabitLocalizations.of(context);
    final days = habitL10n.daysOfWeek;
    final maxValue =
        data.values.isEmpty ? 1 : data.values.reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxValue.toDouble() * 1.2,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < 7) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(days[value.toInt()],
                        style: const TextStyle(fontSize: 11)),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(7, (index) {
          final dayNum = index + 1;
          final count = data[dayNum] ?? 0;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: count.toDouble(),
                color: theme.colorScheme.primary,
                width: 24,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _StreakHistoryChart extends StatelessWidget {
  final List<StreakPeriod> streaks;

  const _StreakHistoryChart({required this.streaks});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sortedStreaks = List<StreakPeriod>.from(streaks)
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: sortedStreaks.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.length.toDouble(),
                color: Colors.orange,
                width: 16,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MonthlyActivityChart extends StatelessWidget {
  final Map<int, int> data;

  const _MonthlyActivityChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final habitL10n = HabitLocalizations.of(context);
    final months = habitL10n.months;
    final maxValue =
        data.values.isEmpty ? 1 : data.values.reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxValue.toDouble() * 1.2,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < 12) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(months[value.toInt()],
                        style: const TextStyle(fontSize: 10)),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(12, (index) {
          final month = index + 1;
          final count = data[month] ?? 0;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: count.toDouble(),
                color: AppTheme.successColor,
                width: 16,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _HeatmapGrid extends StatelessWidget {
  final Map<String, bool> completionHistory;

  const _HeatmapGrid({required this.completionHistory});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final habitL10n = HabitLocalizations.of(context);
    final now = DateTime.now();
    final days = 90;
    final daysOfWeek = habitL10n.daysOfWeek;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weekday labels
          Row(
            children: ['', daysOfWeek[0], '', daysOfWeek[2], '', daysOfWeek[4], '']
                .map((d) => SizedBox(
                      width: 14,
                      height: 14,
                      child: Text(d,
                          style:
                              const TextStyle(fontSize: 8, color: Colors.grey)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 4),
          // Heatmap cells
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildWeeks(now, days, theme),
            ),
          ),
          const SizedBox(height: 12),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(habitL10n.less, style: theme.textTheme.bodySmall),
              const SizedBox(width: 8),
              ...List.generate(5, (i) {
                final alpha = (i * 51).clamp(0, 255);
                return Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i == 0
                        ? Colors.grey.withAlpha(51)
                        : AppTheme.successColor.withAlpha(alpha),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
              const SizedBox(width: 8),
              Text(habitL10n.more, style: theme.textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildWeeks(DateTime now, int days, ThemeData theme) {
    final weeks = <Widget>[];
    final startDate = now.subtract(Duration(days: days));

    for (int w = 0; w <= days ~/ 7; w++) {
      final weekStart = startDate.add(Duration(days: w * 7));
      weeks.add(
        Column(
          children: List.generate(7, (d) {
            final date = weekStart.add(Duration(days: d));
            if (date.isAfter(now)) {
              return const SizedBox(width: 14, height: 14);
            }
            final dateKey = Habit.getDateKey(date);
            final completed = completionHistory[dateKey] ?? false;

            return Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: completed
                    ? AppTheme.successColor
                    : Colors.grey.withAlpha(51),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
      );
    }

    return weeks;
  }
}

extension on List<Habit> {
  List<Habit> sorted(int Function(Habit, Habit) compare) {
    final list = List<Habit>.from(this);
    list.sort(compare);
    return list;
  }
}

