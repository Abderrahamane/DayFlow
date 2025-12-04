/// Constants for date formatting
const List<String> _weekdays = [
  'Monday', 'Tuesday',
  'Wednesday', 'Thursday', 'Friday',
  'Saturday', 'Sunday'
];

const List<String> _months = [
  'January', 'February', 'March', 'April',
  'May', 'June', 'July', 'August',
  'September', 'October', 'November', 'December'
];

/// Returns the current date formatted as "Weekday, Day Month"

String formattedHeaderDate() {
  final now = DateTime.now();
  final wd = _weekdays[now.weekday - 1];
  final m = _months[now.month - 1];
  return '$wd, ${now.day} $m';
}

/// Returns a date formatted as "Weekday, Day Month Year, Hour:Minute"
String formattedDateWithDay(DateTime date) {
  final wd = _weekdays[date.weekday - 1];
  final m = _months[date.month - 1];
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$wd, ${date.day} $m ${date.year}, $hour:$minute';
}

