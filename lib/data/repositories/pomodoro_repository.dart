import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/pomodoro_model.dart';
import '../local/app_database.dart';

class PomodoroRepository {
  final AppDatabase _db;
  static const String _settingsKey = 'pomodoro_settings';

  PomodoroRepository(this._db);

  Future<void> _ensureDb() async => _db.init();

  Future<PomodoroSettings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_settingsKey);
    if (settingsJson != null) {
      try {
        return PomodoroSettings.fromJson(jsonDecode(settingsJson));
      } catch (e) {
        return const PomodoroSettings();
      }
    }
    return const PomodoroSettings();
  }

  Future<void> saveSettings(PomodoroSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }

  Future<List<PomodoroSession>> fetchSessions() async {
    await _ensureDb();
    final result = _db.rawDb.select(
      'SELECT * FROM pomodoro_sessions ORDER BY startTime DESC',
    );
    return result.map((row) => PomodoroSession.fromDatabase(row)).toList();
  }

  Future<List<PomodoroSession>> fetchTodaySessions() async {
    await _ensureDb();
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final result = _db.rawDb.select(
      'SELECT * FROM pomodoro_sessions WHERE startTime >= ? AND startTime < ? ORDER BY startTime DESC',
      [startOfDay.millisecondsSinceEpoch, endOfDay.millisecondsSinceEpoch],
    );
    return result.map((row) => PomodoroSession.fromDatabase(row)).toList();
  }

  Future<List<PomodoroSession>> fetchSessionsForTask(String taskId) async {
    await _ensureDb();
    final result = _db.rawDb.select(
      'SELECT * FROM pomodoro_sessions WHERE linkedTaskId = ? ORDER BY startTime DESC',
      [taskId],
    );
    return result.map((row) => PomodoroSession.fromDatabase(row)).toList();
  }

  Future<void> saveSession(PomodoroSession session) async {
    await _ensureDb();
    final data = session.toDatabase();
    _db.rawDb.execute(
      '''INSERT OR REPLACE INTO pomodoro_sessions 
        (id, type, startTime, endTime, durationMinutes, completed, linkedTaskId, linkedTaskTitle) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)''',
      [
        data['id'],
        data['type'],
        data['startTime'],
        data['endTime'],
        data['durationMinutes'],
        data['completed'],
        data['linkedTaskId'],
        data['linkedTaskTitle'],
      ],
    );
  }

  Future<void> deleteSession(String id) async {
    await _ensureDb();
    _db.rawDb.execute('DELETE FROM pomodoro_sessions WHERE id = ?', [id]);
  }

  Future<PomodoroStats> calculateStats() async {
    await _ensureDb();

    // Get all completed work sessions
    final allSessions = _db.rawDb.select(
      'SELECT * FROM pomodoro_sessions WHERE completed = 1 AND type = 0 ORDER BY startTime DESC',
    );

    if (allSessions.isEmpty) {
      return const PomodoroStats();
    }

    // Calculate totals
    int totalSessions = allSessions.length;
    int totalMinutes = 0;
    final dailySessions = <DateTime, int>{};

    for (final row in allSessions) {
      totalMinutes += row['durationMinutes'] as int;

      final date = DateTime.fromMillisecondsSinceEpoch(row['startTime'] as int);
      final dateOnly = DateTime(date.year, date.month, date.day);
      dailySessions[dateOnly] = (dailySessions[dateOnly] ?? 0) + 1;
    }

    // Calculate today's sessions
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);
    final completedToday = dailySessions[todayKey] ?? 0;

    // Calculate streak
    int streak = 0;
    DateTime checkDate = todayKey;
    while (dailySessions.containsKey(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return PomodoroStats(
      totalWorkSessions: totalSessions,
      totalWorkMinutes: totalMinutes,
      completedToday: completedToday,
      currentStreak: streak,
      dailySessions: dailySessions,
    );
  }
}

