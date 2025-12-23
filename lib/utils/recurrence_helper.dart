import 'package:flutter/material.dart';
import '../models/recurrence_model.dart';
import 'app_localizations.dart';

class RecurrenceHelper {
  static String getDescription(BuildContext context, RecurrencePattern pattern) {
    final l10n = AppLocalizations.of(context);

    switch (pattern.type) {
      case RecurrenceType.none:
        return l10n.recurrenceDoesNotRepeat;
      case RecurrenceType.daily:
        if (pattern.interval == 1) return l10n.recurrenceRepeatsDaily;
        return l10n.recurrenceRepeatsEveryDays.replaceAll('{interval}', pattern.interval.toString());
      case RecurrenceType.weekly:
        if (pattern.daysOfWeek != null && pattern.daysOfWeek!.isNotEmpty) {
          final dayNames = pattern.daysOfWeek!.map((day) => _getDayName(context, day)).join(', ');
          return l10n.recurrenceRepeatsWeeklyOn.replaceAll('{days}', dayNames);
        }
        if (pattern.interval == 1) return l10n.recurrenceRepeatsWeekly;
        return l10n.recurrenceRepeatsEveryWeeks.replaceAll('{interval}', pattern.interval.toString());
      case RecurrenceType.monthly:
        if (pattern.interval == 1) return l10n.recurrenceRepeatsMonthly;
        return l10n.recurrenceRepeatsEveryMonths.replaceAll('{interval}', pattern.interval.toString());
      case RecurrenceType.custom:
        return l10n.recurrenceCustomEveryDays.replaceAll('{interval}', pattern.interval.toString());
    }
  }

  static String _getDayName(BuildContext context, int day) {
    final l10n = AppLocalizations.of(context);
    switch (day) {
      case 1: return l10n.weekdayMonday;
      case 2: return l10n.weekdayTuesday;
      case 3: return l10n.weekdayWednesday;
      case 4: return l10n.weekdayThursday;
      case 5: return l10n.weekdayFriday;
      case 6: return l10n.weekdaySaturday;
      case 7: return l10n.weekdaySunday;
      default: return '';
    }
  }
}

