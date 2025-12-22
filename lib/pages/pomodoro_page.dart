import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/app_localizations.dart';
import '../utils/pomodoro_helper.dart';
import '../blocs/pomodoro/pomodoro_bloc.dart';
import '../blocs/task/task_bloc.dart';
import '../models/pomodoro_model.dart';
import '../theme/app_theme.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    context.read<PomodoroBloc>().add(LoadPomodoroData());
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pomodoroTimer),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showHistory(context),
            tooltip: l10n.sessionHistory,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettings(context),
            tooltip: l10n.settings,
          ),
        ],
      ),
      body: BlocListener<PomodoroBloc, PomodoroState>(
        listenWhen: (previous, current) =>
            previous.status != PomodoroStatus.ringing &&
            current.status == PomodoroStatus.ringing,
        listener: (context, state) => _showAlarmDialog(context),
        child: BlocBuilder<PomodoroBloc, PomodoroState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Stats cards
                  _StatsRow(state: state),
                  const SizedBox(height: 32),

                  // Timer display
                  _TimerDisplay(
                    state: state,
                    pulseController: _pulseController,
                  ),
                  const SizedBox(height: 32),

                  // Session type indicator
                  _SessionTypeIndicator(state: state),
                  const SizedBox(height: 24),

                  // Controls
                  _TimerControls(state: state),
                  const SizedBox(height: 32),

                  // Linked task
                  _LinkedTaskCard(state: state),
                  const SizedBox(height: 24),

                  // Today's sessions
                  _TodaySessionsList(sessions: state.todaySessions),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<PomodoroBloc>(),
        child: const _HistorySheet(),
      ),
    );
  }

  void _showAlarmDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.timerFinished),
        content: Text(l10n.whatWouldYouLikeToDo),
        actions: [
          TextButton(
            onPressed: () {
              context.read<PomodoroBloc>().add(ExtendSession());
              Navigator.pop(context);
            },
            child: Text(l10n.extend5m),
          ),
          FilledButton(
            onPressed: () {
              context.read<PomodoroBloc>().add(CompleteSession());
              Navigator.pop(context);
            },
            child: Text(l10n.stop),
          ),
        ],
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<PomodoroBloc>(),
        child: const _SettingsSheet(),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final PomodoroState state;

  const _StatsRow({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle,
            value: '${state.todayWorkSessions}',
            label: l10n.sessionsLabel,
            color: AppTheme.successColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.timer,
            value: '${state.todayTotalMinutes}m',
            label: l10n.focusTime,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.local_fire_department,
            value: '${state.stats.currentStreak}',
            label: l10n.streak,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
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
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimerDisplay extends StatelessWidget {
  final PomodoroState state;
  final AnimationController pulseController;

  const _TimerDisplay({
    required this.state,
    required this.pulseController,
  });

  Color _getSessionColor(PomodoroSessionType? type, ThemeData theme) {
    switch (type) {
      case PomodoroSessionType.work:
        return theme.colorScheme.primary;
      case PomodoroSessionType.shortBreak:
        return AppTheme.successColor;
      case PomodoroSessionType.longBreak:
        return Colors.teal;
      default:
        return theme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sessionColor = _getSessionColor(state.currentSession?.type, theme);

    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        final scale = state.isRunning
            ? 1.0 + (pulseController.value * 0.02)
            : 1.0;

        return Transform.scale(
          scale: scale,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              SizedBox(
                width: 280,
                height: 280,
                child: CustomPaint(
                  painter: _TimerPainter(
                    progress: state.progress,
                    color: sessionColor,
                    backgroundColor: sessionColor.withAlpha(51),
                  ),
                ),
              ),
              // Time display
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.currentSession != null
                        ? state.formattedTime
                        : '${state.settings.workDuration}:00',
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                      fontSize: 64,
                      letterSpacing: 2,
                    ),
                  ),
                  if (state.currentSession != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: sessionColor.withAlpha(26),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        PomodoroHelper.getSessionTypeLabel(context, state.currentSession!.type),
                        style: TextStyle(
                          color: sessionColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimerPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _TimerPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 12.0;

    // Background arc
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_TimerPainter oldDelegate) =>
      progress != oldDelegate.progress || color != oldDelegate.color;
}

class _SessionTypeIndicator extends StatelessWidget {
  final PomodoroState state;

  const _SessionTypeIndicator({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = state.settings;
    final sessionsBeforeLongBreak = settings.sessionsBeforeLongBreak;
    final currentSession = state.completedWorkSessions % sessionsBeforeLongBreak;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(sessionsBeforeLongBreak, (index) {
        final isCompleted = index < currentSession;
        final isCurrent = index == currentSession && state.isRunning;

        return Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? theme.colorScheme.primary
                : isCurrent
                    ? theme.colorScheme.primary.withAlpha(128)
                    : theme.colorScheme.primary.withAlpha(51),
            border: isCurrent
                ? Border.all(color: theme.colorScheme.primary, width: 2)
                : null,
          ),
        );
      }),
    );
  }
}

class _TimerControls extends StatelessWidget {
  final PomodoroState state;

  const _TimerControls({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    if (state.isIdle) {
      return Column(
        children: [
          // Session type buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: PomodoroSessionType.values.map((type) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: OutlinedButton(
                  onPressed: () => context
                      .read<PomodoroBloc>()
                      .add(StartSession(type: type)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: Text('${type.icon} ${PomodoroHelper.getSessionTypeLabel(context, type)}'),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          // Main start button
          FilledButton.icon(
            onPressed: () =>
                context.read<PomodoroBloc>().add(const StartSession()),
            icon: const Icon(Icons.play_arrow, size: 28),
            label: Text(l10n.startFocus, style: const TextStyle(fontSize: 18)),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Stop button
        IconButton.filled(
          onPressed: () => context.read<PomodoroBloc>().add(StopSession()),
          icon: const Icon(Icons.stop),
          iconSize: 32,
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.errorColor,
            padding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(width: 24),
        // Play/Pause button
        IconButton.filled(
          onPressed: () {
            if (state.isRunning) {
              context.read<PomodoroBloc>().add(PauseSession());
            } else {
              context.read<PomodoroBloc>().add(ResumeSession());
            }
          },
          icon: Icon(state.isRunning ? Icons.pause : Icons.play_arrow),
          iconSize: 48,
          style: IconButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            padding: const EdgeInsets.all(24),
          ),
        ),
        const SizedBox(width: 24),
        // Skip button
        IconButton.filled(
          onPressed: () =>
              context.read<PomodoroBloc>().add(SkipToNextSession()),
          icon: const Icon(Icons.skip_next),
          iconSize: 32,
          style: IconButton.styleFrom(
            backgroundColor: theme.colorScheme.secondary,
            padding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}

class _LinkedTaskCard extends StatelessWidget {
  final PomodoroState state;

  const _LinkedTaskCard({required this.state});

  void _showTaskPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<TaskBloc>()),
          BlocProvider.value(value: context.read<PomodoroBloc>()),
        ],
        child: const _TaskPickerSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    if (state.linkedTaskId == null) {
      return OutlinedButton.icon(
        onPressed: () => _showTaskPicker(context),
        icon: const Icon(Icons.link),
        label: Text(l10n.linkToTask),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(77)),
      ),
      child: Row(
        children: [
          Icon(Icons.task_alt, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.workingOn,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  state.linkedTaskTitle ?? l10n.task,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () =>
                context.read<PomodoroBloc>().add(ClearLinkedTask()),
          ),
        ],
      ),
    );
  }
}

class _TodaySessionsList extends StatelessWidget {
  final List<PomodoroSession> sessions;

  const _TodaySessionsList({required this.sessions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final workSessions = sessions
        .where((s) => s.type == PomodoroSessionType.work && s.completed)
        .toList();

    if (workSessions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              Icons.timer_outlined,
              size: 48,
              color: theme.colorScheme.primary.withAlpha(128),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.noSessionsToday,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withAlpha(179),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.startFocusSessionMsg,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.todaysSessions,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...workSessions.take(5).map((session) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      session.type.icon,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.linkedTaskTitle ?? l10n.focusSession,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${session.durationMinutes} ${l10n.minutes}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _formatTime(session.startTime),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            )),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _TaskPickerSheet extends StatelessWidget {
  const _TaskPickerSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              l10n.selectTask,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                final incompleteTasks =
                    state.tasks.where((t) => !t.isCompleted).toList();

                if (incompleteTasks.isEmpty) {
                  return Center(child: Text(l10n.noPendingTasks));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: incompleteTasks.length,
                  itemBuilder: (context, index) {
                    final task = incompleteTasks[index];
                    return ListTile(
                      leading: const Icon(Icons.task_alt),
                      title: Text(task.title),
                      subtitle: task.dueDate != null
                          ? Text('${l10n.duePrefix}${_formatDate(task.dueDate!)}')
                          : null,
                      onTap: () {
                        context.read<PomodoroBloc>().add(LinkTaskToSession(
                              taskId: task.id,
                              taskTitle: task.title,
                            ));
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}

class _HistorySheet extends StatelessWidget {
  const _HistorySheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  l10n.sessionHistory,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                BlocBuilder<PomodoroBloc, PomodoroState>(
                  builder: (context, state) {
                    return Text(
                      '${state.stats.totalWorkSessions}${l10n.sessionsSuffix}',
                      style: theme.textTheme.bodyMedium,
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<PomodoroBloc, PomodoroState>(
              builder: (context, state) {
                final sessions = state.sessionHistory
                    .where((s) => s.type == PomodoroSessionType.work)
                    .toList();

                if (sessions.isEmpty) {
                  return Center(child: Text(l10n.noSessionsYet));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
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
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: session.completed
                                  ? AppTheme.successColor.withAlpha(26)
                                  : Colors.grey.withAlpha(51),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              session.completed
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: session.completed
                                  ? AppTheme.successColor
                                  : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  session.linkedTaskTitle ?? l10n.focusSession,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${session.durationMinutes} ${l10n.minSuffix} • ${_formatDateTime(session.startTime)}',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.month}/${dt.day} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _SettingsSheet extends StatefulWidget {
  const _SettingsSheet();

  @override
  State<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<_SettingsSheet> {
  late PomodoroSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = context.read<PomodoroBloc>().state.settings;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  l10n.timerSettings,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    context
                        .read<PomodoroBloc>()
                        .add(UpdateSettings(_settings));
                    Navigator.pop(context);
                  },
                  child: Text(l10n.save),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _SettingSlider(
                  label: l10n.workDuration,
                  value: _settings.workDuration.toDouble(),
                  min: 5,
                  max: 60,
                  suffix: l10n.minSuffix,
                  onChanged: (v) => setState(
                      () => _settings = _settings.copyWith(workDuration: v.round())),
                ),
                _SettingSlider(
                  label: l10n.shortBreak,
                  value: _settings.shortBreakDuration.toDouble(),
                  min: 1,
                  max: 15,
                  suffix: l10n.minSuffix,
                  onChanged: (v) => setState(
                      () => _settings = _settings.copyWith(shortBreakDuration: v.round())),
                ),
                _SettingSlider(
                  label: l10n.longBreak,
                  value: _settings.longBreakDuration.toDouble(),
                  min: 10,
                  max: 30,
                  suffix: l10n.minSuffix,
                  onChanged: (v) => setState(
                      () => _settings = _settings.copyWith(longBreakDuration: v.round())),
                ),
                _SettingSlider(
                  label: l10n.sessionsBeforeLongBreak,
                  value: _settings.sessionsBeforeLongBreak.toDouble(),
                  min: 2,
                  max: 8,
                  suffix: '',
                  onChanged: (v) => setState(
                      () => _settings = _settings.copyWith(sessionsBeforeLongBreak: v.round())),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: Text(l10n.autoStartBreaks),
                  subtitle: Text(l10n.autoStartBreaksDesc),
                  value: _settings.autoStartBreaks,
                  onChanged: (v) => setState(
                      () => _settings = _settings.copyWith(autoStartBreaks: v)),
                ),
                SwitchListTile(
                  title: Text(l10n.autoStartWork),
                  subtitle: Text(l10n.autoStartWorkDesc),
                  value: _settings.autoStartWork,
                  onChanged: (v) => setState(
                      () => _settings = _settings.copyWith(autoStartWork: v)),
                ),
                SwitchListTile(
                  title: Text(l10n.sound),
                  subtitle: Text(l10n.soundDesc),
                  value: _settings.soundEnabled,
                  onChanged: (v) => setState(
                      () => _settings = _settings.copyWith(soundEnabled: v)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String suffix;
  final ValueChanged<double> onChanged;

  const _SettingSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.suffix,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.bodyMedium),
            Text(
              '${value.round()}$suffix',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).round(),
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

