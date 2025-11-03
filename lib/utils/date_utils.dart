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

