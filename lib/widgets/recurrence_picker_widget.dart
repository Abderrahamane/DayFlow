import 'package:flutter/material.dart';
import '../models/recurrence_model.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recurrence type selector
        Text(
          'Repeat',
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
              label: Text('${type.icon} ${type.displayName}'),
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
                Text('Every', style: theme.textTheme.bodyMedium),
                const SizedBox(width: 12),
                SizedBox(
                  width: 60,
                  child: DropdownButtonFormField<int>(
                    value: _interval,
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
                  _getIntervalLabel(),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Weekly day selector
          if (_type == RecurrenceType.weekly) ...[
            Text(
              'On these days',
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
                Text('On day', style: theme.textTheme.bodyMedium),
                const SizedBox(width: 12),
                SizedBox(
                  width: 70,
                  child: DropdownButtonFormField<int>(
                    value: _dayOfMonth ?? DateTime.now().day,
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
                Text('of the month', style: theme.textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // End options
          const Divider(),
          const SizedBox(height: 8),
          Text(
            'Ends',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

          // End date option
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Radio<RecurrenceEndType>(
              value: RecurrenceEndType.date,
              groupValue: _endType,
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
                ? 'On ${_formatDate(_endDate!)}'
                : 'On specific date'),
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
              value: RecurrenceEndType.occurrences,
              groupValue: _endType,
              onChanged: (_) => _setMaxOccurrences(),
            ),
            title: Row(
              children: [
                const Text('After '),
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
                const Text(' occurrences'),
              ],
            ),
            onTap: _setMaxOccurrences,
          ),

          // Never ends option
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Radio<RecurrenceEndType>(
              value: RecurrenceEndType.never,
              groupValue: _endType,
              onChanged: (_) {
                setState(() {
                  _endDate = null;
                  _maxOccurrences = null;
                  _endType = RecurrenceEndType.never;
                });
                _notifyChange();
              },
            ),
            title: const Text('Never'),
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

  String _getIntervalLabel() {
    switch (_type) {
      case RecurrenceType.daily:
        return _interval == 1 ? 'day' : 'days';
      case RecurrenceType.weekly:
        return _interval == 1 ? 'week' : 'weeks';
      case RecurrenceType.monthly:
        return _interval == 1 ? 'month' : 'months';
      default:
        return _interval == 1 ? 'day' : 'days';
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

    String summary = pattern.description;
    if (_endDate != null) {
      summary += ' until ${_formatDate(_endDate!)}';
    } else if (_maxOccurrences != null) {
      summary += ' ($_maxOccurrences times)';
    }
    return summary;
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
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
