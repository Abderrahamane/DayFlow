import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/habit/habit_bloc.dart';
import '../models/habit_model.dart' as habit_model;
import '../widgets/habit_card.dart';
import '../utils/routes.dart';
import '../utils/habit_localizations.dart';

class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key});

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  @override
  void initState() {
    super.initState();
    context.read<HabitBloc>().add(LoadHabits());
  }

  void _openHabitSheet({habit_model.Habit? habit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _HabitEditor(habit: habit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final habitL10n = HabitLocalizations.of(context);

    return Scaffold(
      body: BlocBuilder<HabitBloc, HabitState>(
        builder: (context, state) {
          if (state.status == HabitStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == HabitStatus.failure) {
            return Center(
              child: Text(state.errorMessage ?? 'Failed to load habits'),
            );
          }

          final habits = state.habits;

          if (habits.isEmpty) {
            return _EmptyState(theme: theme);
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            habitL10n.todaysProgress,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () => Routes.navigateToHabitStats(context),
                            icon: const Icon(Icons.bar_chart, size: 18),
                            label: Text(habitL10n.stats),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              icon: Icons.check_circle_outline,
                              value: '${state.completedToday}',
                              label: habitL10n.completed,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.local_fire_department_outlined,
                              value: '${state.activeStreaks}',
                              label: habitL10n.streaks,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.trending_up,
                              value: '${state.todayCompletionPercentage.toInt()}%',
                              label: habitL10n.rate,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final habit = habits[index];
                      return HabitCard(
                        habit: habit,
                        onTap: () => _openHabitSheet(habit: habit),
                        onToggle: () => context.read<HabitBloc>().add(
                              ToggleHabitCompletionEvent(
                                habitId: habit.id,
                                dateKey: habit_model.Habit.getDateKey(DateTime.now()),
                              ),
                            ),
                      );
                    },
                    childCount: habits.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openHabitSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _HabitEditor extends StatefulWidget {
  final habit_model.Habit? habit;

  const _HabitEditor({this.habit});

  @override
  State<_HabitEditor> createState() => _HabitEditorState();
}

class _HabitEditorState extends State<_HabitEditor> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _iconController;
  late final TextEditingController _tagsController;
  int _goalCount = 7;
  habit_model.HabitFrequency _frequency = habit_model.HabitFrequency.daily;
  Color _selectedColor = const Color(0xFF6366F1);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.habit?.description ?? '');
    _iconController = TextEditingController(text: widget.habit?.icon ?? '📝');
    _tagsController = TextEditingController(
      text: widget.habit?.linkedTaskTags.join(', ') ?? '',
    );
    _goalCount = widget.habit?.goalCount ?? 7;
    _frequency = widget.habit?.frequency ?? habit_model.HabitFrequency.daily;
    _selectedColor = widget.habit?.color ?? const Color(0xFF6366F1);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _iconController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _saveHabit() {
    if (!_formKey.currentState!.validate()) return;

    final tags = _tagsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final habit = habit_model.Habit(
      id: widget.habit?.id ?? '',
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      icon: _iconController.text.trim().isEmpty
          ? '📝'
          : _iconController.text.trim(),
      frequency: _frequency,
      goalCount: _goalCount,
      linkedTaskTags: tags,
      completionHistory: widget.habit?.completionHistory,
      createdAt: widget.habit?.createdAt ?? DateTime.now(),
      color: _selectedColor,
    );

    context.read<HabitBloc>().add(AddOrUpdateHabit(habit));
    Navigator.pop(context);

    final habitL10n = HabitLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.habit == null ? habitL10n.habitAdded : habitL10n.habitUpdated),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final habitL10n = HabitLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.habit == null ? habitL10n.createHabit : habitL10n.editHabit,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: habitL10n.habitName,
                    prefixIcon: const Icon(Icons.stars_outlined),
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? habitL10n.required : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: habitL10n.description,
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _iconController,
                  decoration: InputDecoration(
                    labelText: habitL10n.emojiIcon,
                    prefixIcon: const Icon(Icons.emoji_emotions_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _tagsController,
                  decoration: InputDecoration(
                    labelText: habitL10n.linkedTaskTags,
                    prefixIcon: const Icon(Icons.sell_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<habit_model.HabitFrequency>(
                        initialValue: _frequency,
                        decoration: InputDecoration(
                          labelText: habitL10n.frequency,
                        ),
                        items: habit_model.HabitFrequency.values
                            .map(
                              (f) => DropdownMenuItem(
                                value: f,
                                child: Text(f.displayName),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) setState(() => _frequency = value);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        initialValue: '$_goalCount',
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: habitL10n.weeklyGoal,
                        ),
                        onChanged: (value) {
                          final parsed = int.tryParse(value);
                          if (parsed != null) setState(() => _goalCount = parsed);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(habitL10n.color),
                    const SizedBox(width: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        Colors.indigo,
                        Colors.green,
                        Colors.pink,
                        Colors.orange,
                        Colors.blueGrey,
                      ]
                          .map(
                            (color) => GestureDetector(
                              onTap: () => setState(() => _selectedColor = color),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _selectedColor == color
                                        ? theme.colorScheme.onPrimary
                                        : Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveHabit,
                    child:
                        Text(widget.habit == null ? habitL10n.addHabit : habitL10n.updateHabit),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.brightness == Brightness.light
              ? Colors.grey.shade200
              : Colors.grey.shade800,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ThemeData theme;

  const _EmptyState({required this.theme});

  @override
  Widget build(BuildContext context) {
    final habitL10n = HabitLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.stars_outlined,
                size: 60,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              habitL10n.noHabitsYet,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              habitL10n.createFirstHabit,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
