import 'package:flutter/material.dart' as material;
// as material to avoid conflict with showDatePicker build-in class
import 'package:flutter/material.dart';

class DateTimePicker {
  // Show custom styled date picker
  static Future<DateTime?> showDatePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String? helpText,
  }) async {
    final theme = Theme.of(context);

    return await material.showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime(2030),
      helpText: helpText ?? 'Select Date',
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onPrimary: Colors.white,
              surface: theme.colorScheme.surface,
              onSurface: theme.textTheme.bodyLarge?.color ?? Colors.black,
            ),
            dialogBackgroundColor: theme.colorScheme.surface,
          ),
          child: child!,
        );
      },
    );
  }

  // Show custom styled time picker
  static Future<TimeOfDay?> showTimePicker({
    required BuildContext context,
    TimeOfDay? initialTime,
    String? helpText,
  }) async {
    final theme = Theme.of(context);

    return await material.showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      helpText: helpText ?? 'Select Time',
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onPrimary: Colors.white,
              surface: theme.colorScheme.surface,
              onSurface: theme.textTheme.bodyLarge?.color ?? Colors.black,
            ),
            dialogBackgroundColor: theme.colorScheme.surface,
          ),
          child: child!,
        );
      },
    );
  }

  // Show combined date and time picker
  static Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDateTime,
  }) async {
    final date = await DateTimePicker.showDatePicker(
      context: context,
      initialDate: initialDateTime,
    );

    if (date == null) return null;

    if (!context.mounted) return null;

    final time = await DateTimePicker.showTimePicker(
      context: context,
      initialTime: initialDateTime != null
          ? TimeOfDay.fromDateTime(initialDateTime)
          : null,
    );

    if (time == null) return null;

    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }
}

// Date picker input field
class DatePickerField extends StatefulWidget {
  final String? label;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(DateTime?)? onChanged;
  final String? hint;
  final bool enabled;
  final IconData? prefixIcon;

  const DatePickerField({
    super.key,
    this.label,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.hint,
    this.enabled = true,
    this.prefixIcon,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _selectDate() async {
    final date = await DateTimePicker.showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
      if (widget.onChanged != null) {
        widget.onChanged!(date);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        InkWell(
          onTap: widget.enabled ? _selectDate : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                if (widget.prefixIcon != null) ...[
                  Icon(
                    widget.prefixIcon,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? _formatDate(_selectedDate!)
                        : widget.hint ?? 'Select date',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: _selectedDate != null
                          ? theme.textTheme.bodyLarge?.color
                          : theme.textTheme.bodyMedium?.color
                          ?.withOpacity(0.5),
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Time picker input field
class TimePickerField extends StatefulWidget {
  final String? label;
  final TimeOfDay? initialTime;
  final void Function(TimeOfDay?)? onChanged;
  final String? hint;
  final bool enabled;
  final IconData? prefixIcon;

  const TimePickerField({
    super.key,
    this.label,
    this.initialTime,
    this.onChanged,
    this.hint,
    this.enabled = true,
    this.prefixIcon,
  });

  @override
  State<TimePickerField> createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _selectTime() async {
    final time = await DateTimePicker.showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
      if (widget.onChanged != null) {
        widget.onChanged!(time);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        InkWell(
          onTap: widget.enabled ? _selectTime : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                if (widget.prefixIcon != null) ...[
                  Icon(
                    widget.prefixIcon,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    _selectedTime != null
                        ? _formatTime(_selectedTime!)
                        : widget.hint ?? 'Select time',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: _selectedTime != null
                          ? theme.textTheme.bodyLarge?.color
                          : theme.textTheme.bodyMedium?.color
                          ?.withOpacity(0.5),
                    ),
                  ),
                ),
                Icon(
                  Icons.access_time,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// DateTime picker input field (combined date and time)
class DateTimePickerField extends StatefulWidget {
  final String? label;
  final DateTime? initialDateTime;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(DateTime?)? onChanged;
  final String? hint;
  final bool enabled;
  final IconData? prefixIcon;

  const DateTimePickerField({
    super.key,
    this.label,
    this.initialDateTime,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.hint,
    this.enabled = true,
    this.prefixIcon,
  });

  @override
  State<DateTimePickerField> createState() => _DateTimePickerFieldState();
}

class _DateTimePickerFieldState extends State<DateTimePickerField> {
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime;
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year} at $hour:$minute $period';
  }

  Future<void> _selectDateTime() async {
    final dateTime = await DateTimePicker.showDateTimePicker(
      context: context,
      initialDateTime: _selectedDateTime,
    );

    if (dateTime != null) {
      setState(() {
        _selectedDateTime = dateTime;
      });
      if (widget.onChanged != null) {
        widget.onChanged!(dateTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        InkWell(
          onTap: widget.enabled ? _selectDateTime : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                if (widget.prefixIcon != null) ...[
                  Icon(
                    widget.prefixIcon,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    _selectedDateTime != null
                        ? _formatDateTime(_selectedDateTime!)
                        : widget.hint ?? 'Select date and time',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: _selectedDateTime != null
                          ? theme.textTheme.bodyLarge?.color
                          : theme.textTheme.bodyMedium?.color
                          ?.withOpacity(0.5),
                    ),
                  ),
                ),
                Icon(
                  Icons.event,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}