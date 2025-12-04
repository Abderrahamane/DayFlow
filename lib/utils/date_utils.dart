/// Returns the current date formatted as "Weekday, Day Month"

String formattedHeaderDate() {
  final now = DateTime.now();
  const weekdays = [
    'Monday', 'Tuesday',
    'Wednesday', 'Thursday', 'Friday',
    'Saturday', 'Sunday'
  ];
  const months = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December'
  ];
  final wd = weekdays[now.weekday - 1];
  final m = months[now.month - 1];
  return '$wd, ${now.day} $m';
}

/// Returns a date formatted as "Weekday, Day Month Year, Hour:Minute"
String formattedDateWithDay(DateTime date) {
  const weekdays = [
    'Monday', 'Tuesday',
    'Wednesday', 'Thursday', 'Friday',
    'Saturday', 'Sunday'
  ];
  const months = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December'
  ];
  final wd = weekdays[date.weekday - 1];
  final m = months[date.month - 1];
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$wd, ${date.day} $m ${date.year}, $hour:$minute';
}

