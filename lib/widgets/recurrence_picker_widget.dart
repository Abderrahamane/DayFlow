import 'package:flutter/material.dart';
import '../models/recurrence_model.dart';
import '../utils/app_localizations.dart';
import '../utils/recurrence_helper.dart';

enum RecurrenceEndType { never, date, occurrences }

class RecurrencePickerWidget extends StatefulWidget {
  final RecurrencePattern? initialPattern;
  final ValueChanged<RecurrencePattern?> onChanged;

  const RecurrencePickerWidget({
    super.key,
    this.initialPattern,
    required this.onChanged,
  });

  @override
  State<RecurrencePickerWidget> createState() => _RecurrencePickerWidgetState();
}

class _RecurrencePickerWidgetState extends State<RecurrencePickerWidget> {
  late RecurrenceType _type;
  late int _interval;
  late List<int> _selectedDays;
  int? _dayOfMonth;
  DateTime? _endDate;
  int? _maxOccurrences;

  late RecurrenceEndType _endType;
  late TextEditingController _occurrencesController;

  @override
  void initState() {
    super.initState();
    final pattern = widget.initialPattern;
    _type = pattern?.type ?? RecurrenceType.none;
    _interval = pattern?.interval ?? 1;
    _selectedDays = pattern?.daysOfWeek ?? [];
    _dayOfMonth = pattern?.dayOfMonth;
    _endDate = pattern?.endDate;
    _maxOccurrences = pattern?.maxOccurrences;

    if (_endDate != null) {
      _endType = RecurrenceEndType.date;
    } else if (_maxOccurrences != null) {
      _endType = RecurrenceEndType.occurrences;
    } else {
      _endType = RecurrenceEndType.never;
    }

    _occurrencesController = TextEditingController(
      text: _maxOccurrences?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _occurrencesController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    if (_type == RecurrenceType.none) {
      widget.onChanged(null);
      return;
    }

    widget.onChanged(RecurrencePattern(
      type: _type,
      interval: _interval,
      daysOfWeek: _type == RecurrenceType.weekly ? _selectedDays : null,
      dayOfMonth: _type == RecurrenceType.monthly ? _dayOfMonth : null,
      endDate: _endDate,
      maxOccurrences: _maxOccurrences,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recurrence type selector
        Text(
          l10n.repeat,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: RecurrenceType.values.map((type) {
            final isSelected = _type == type;
            return FilterChip(
              label: Text('${type.icon} ${_getRecurrenceLabel(context, type)}'),
              selected: isSelected,
              onSelected: (_) {
                setState(() => _type = type);
                _notifyChange();
              },
            );
          }).toList(),
        ),

        if (_type != RecurrenceType.none) ...[
          const SizedBox(height: 20),

          // Interval selector
          if (_type != RecurrenceType.weekly || _selectedDays.isEmpty) ...[
            Row(
              children: [
                Text(l10n.recurrenceEvery, style: theme.textTheme.bodyMedium),
                const SizedBox(width: 12),
                SizedBox(
                  width: 60,
                  child: DropdownButtonFormField<int>(
                    key: ValueKey(_interval),
                    initialValue: _interval,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: List.generate(30, (i) => i + 1)
                        .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
                        .toList(),
                    onChanged: (v) {
                      setState(() => _interval = v ?? 1);
                      _notifyChange();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _getIntervalLabel(context),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Weekly day selector
          if (_type == RecurrenceType.weekly) ...[
            Text(
              l10n.recurrenceOnTheseDays,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _DayButton('M', 1, _selectedDays.contains(1), _toggleDay),
                _DayButton('T', 2, _selectedDays.contains(2), _toggleDay),
                _DayButton('W', 3, _selectedDays.contains(3), _toggleDay),
                _DayButton('T', 4, _selectedDays.contains(4), _toggleDay),
                _DayButton('F', 5, _selectedDays.contains(5), _toggleDay),
                _DayButton('S', 6, _selectedDays.contains(6), _toggleDay),
                _DayButton('S', 7, _selectedDays.contains(7), _toggleDay),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Monthly day selector
          if (_type == RecurrenceType.monthly) ...[
            Row(
              children: [
                Text(l10n.recurrenceOnDay, style: theme.textTheme.bodyMedium),
                const SizedBox(width: 12),
                SizedBox(
                  width: 70,
                  child: DropdownButtonFormField<int>(
                    key: ValueKey(_dayOfMonth),
                    initialValue: _dayOfMonth ?? DateTime.now().day,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: List.generate(31, (i) => i + 1)
                        .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
                        .toList(),
                    onChanged: (v) {
                      setState(() => _dayOfMonth = v);
                      _notifyChange();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Text(l10n.recurrenceOfTheMonth, style: theme.textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // End options
          const Divider(),
          const SizedBox(height: 8),
          Text(
            l10n.recurrenceEnds,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

          // End date option
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Radio<RecurrenceEndType>(
              // ignore: deprecated_member_use
              value: RecurrenceEndType.date,
              // ignore: deprecated_member_use
              groupValue: _endType,
              // ignore: deprecated_member_use
              onChanged: (_) {
                setState(() {
                  _endType = RecurrenceEndType.date;
                  _endDate = DateTime.now().add(const Duration(days: 30));
                  _maxOccurrences = null;
                });
                _notifyChange();
              },
            ),
            title: Text(_endDate != null
                ? '${l10n.recurrenceOnDate} ${_formatDate(_endDate!)}'
                : l10n.recurrenceOnSpecificDate),
            trailing: _endDate != null
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      setState(() => _endDate = null);
                      _notifyChange();
                    },
                  )
                : null,
            onTap: _selectEndDate,
          ),

          // Max occurrences option
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Radio<RecurrenceEndType>(
              // ignore: deprecated_member_use
              value: RecurrenceEndType.occurrences,
              // ignore: deprecated_member_use
              groupValue: _endType,
              // ignore: deprecated_member_use
              onChanged: (_) => _setMaxOccurrences(),
            ),
            title: Row(
              children: [
                Text('${l10n.recurrenceAfter} '),
                SizedBox(
                  width: 50,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                    controller: _occurrencesController,
                    onChanged: (v) {
                      setState(() => _maxOccurrences = int.tryParse(v));
                      _notifyChange();
                    },
                  ),
                ),
                Text(' ${l10n.recurrenceOccurrences}'),
              ],
            ),
            onTap: _setMaxOccurrences,
          ),

          // Never ends option
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Radio<RecurrenceEndType>(
              // ignore: deprecated_member_use
              value: RecurrenceEndType.never,
              // ignore: deprecated_member_use
              groupValue: _endType,
              // ignore: deprecated_member_use
              onChanged: (_) {
                setState(() {
                  _endDate = null;
                  _maxOccurrences = null;
                  _endType = RecurrenceEndType.never;
                });
                _notifyChange();
              },
            ),
            title: Text(l10n.recurrenceNever),
            onTap: () {
              setState(() {
                _endDate = null;
                _maxOccurrences = null;
                _endType = RecurrenceEndType.never;
              });
              _notifyChange();
            },
          ),
        ],

        // Summary
        if (_type != RecurrenceType.none) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.repeat, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getSummary(),
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
      _selectedDays.sort();
    });
    _notifyChange();
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (date != null) {
      setState(() {
        _endDate = date;
        _maxOccurrences = null;
        _endType = RecurrenceEndType.date;
      });
      _notifyChange();
    }
  }

  void _setMaxOccurrences() {
    setState(() {
      final int? value = int.tryParse(_occurrencesController.text);
      _maxOccurrences = value ?? 10;
      if (value == null) {
        _occurrencesController.text = _maxOccurrences.toString();
      }
      _endDate = null;
      _endType = RecurrenceEndType.occurrences;
    });
    _notifyChange();
  }

  String _getIntervalLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (_type) {
      case RecurrenceType.daily:
        return _interval == 1 ? l10n.recurrenceDay : l10n.recurrenceDays;
      case RecurrenceType.weekly:
        return _interval == 1 ? l10n.recurrenceWeek : l10n.recurrenceWeeks;
      case RecurrenceType.monthly:
        return _interval == 1 ? l10n.recurrenceMonth : l10n.recurrenceMonths;
      default:
        return _interval == 1 ? l10n.recurrenceDay : l10n.recurrenceDays;
    }
  }

  String _getSummary() {
    final pattern = RecurrencePattern(
      type: _type,
      interval: _interval,
      daysOfWeek: _type == RecurrenceType.weekly ? _selectedDays : null,
      dayOfMonth: _dayOfMonth,
      endDate: _endDate,
      maxOccurrences: _maxOccurrences,
    );

    // Note: pattern.description is not localized here, ideally it should be.
    // For now we just localize the suffix.
    String summary = RecurrenceHelper.getDescription(context, pattern);
    final l10n = AppLocalizations.of(context);
    if (_endDate != null) {
      summary += ' ${l10n.recurrenceUntil} ${_formatDate(_endDate!)}';
    } else if (_maxOccurrences != null) {
      summary += ' ($_maxOccurrences ${l10n.recurrenceTimes})';
    }
    return summary;
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  String _getRecurrenceLabel(BuildContext context, RecurrenceType type) {
    final l10n = AppLocalizations.of(context);
    switch (type) {
      case RecurrenceType.none:
        return l10n.recurrenceNone;
      case RecurrenceType.daily:
        return l10n.recurrenceDaily;
      case RecurrenceType.weekly:
        return l10n.recurrenceWeekly;
      case RecurrenceType.monthly:
        return l10n.recurrenceMonthly;
      case RecurrenceType.custom:
        return l10n.recurrenceCustom;
    }
  }
}

class _DayButton extends StatelessWidget {
  final String label;
  final int day;
  final bool isSelected;
  final Function(int) onTap;

  const _DayButton(this.label, this.day, this.isSelected, this.onTap);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => onTap(day),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surface,
          border: isSelected
              ? null
              : Border.all(color: theme.dividerColor),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : theme.textTheme.bodyMedium?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
