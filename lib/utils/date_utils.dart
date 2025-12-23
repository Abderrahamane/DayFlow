import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Returns the current date formatted as "Weekday, Day Month"
String formattedHeaderDate(BuildContext context) {
  final locale = Localizations.localeOf(context).toString();
  return DateFormat('EEEE, d MMMM', locale).format(DateTime.now());
}

/// Returns a date formatted as "Weekday, Day Month Year, Hour:Minute"
String formattedDateWithDay(DateTime date, BuildContext context) {
  final locale = Localizations.localeOf(context).toString();
  return DateFormat('EEEE, d MMMM y, HH:mm', locale).format(date);
}

