import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dayflow/services/firestore_service.dart';
import '../../models/pomodoro_model.dart';
import '../local/app_database.dart';

class PomodoroRepository {
  final AppDatabase _localDb;
  final FirestoreService _firestoreService;
  static const String _settingsKey = 'pomodoro_settings';

  PomodoroRepository(this._localDb, this._firestoreService);

  bool get _isRemote => _firestoreService.currentUserId != null;

  Future<void> _ensureDb() async => _localDb.init();

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
    if (_isRemote) {
      final collection = _firestoreService.pomodoroSessions;
      if (collection == null) return [];

      final snapshot = await collection.orderBy('startTime', descending: true).get();
      return snapshot.docs.map((doc) {
        return PomodoroSession.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } else {
      await _ensureDb();
      final result = _localDb.rawDb.select(
        'SELECT * FROM pomodoro_sessions ORDER BY startTime DESC',
      );
      return result.map((row) => PomodoroSession.fromDatabase(row)).toList();
    }
  }

  Future<List<PomodoroSession>> fetchTodaySessions() async {
    if (_isRemote) {
      final collection = _firestoreService.pomodoroSessions;
      if (collection == null) return [];

      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await collection
          .where('startTime', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('startTime', isLessThan: endOfDay.toIso8601String())
          .orderBy('startTime', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return PomodoroSession.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } else {
      await _ensureDb();
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final result = _localDb.rawDb.select(
        'SELECT * FROM pomodoro_sessions WHERE startTime >= ? AND startTime < ? ORDER BY startTime DESC',
        [startOfDay.millisecondsSinceEpoch, endOfDay.millisecondsSinceEpoch],
      );
      return result.map((row) => PomodoroSession.fromDatabase(row)).toList();
    }
  }

  Future<List<PomodoroSession>> fetchSessionsForTask(String taskId) async {
    if (_isRemote) {
      final collection = _firestoreService.pomodoroSessions;
      if (collection == null) return [];

      final snapshot = await collection
          .where('linkedTaskId', isEqualTo: taskId)
          .orderBy('startTime', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return PomodoroSession.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } else {
      await _ensureDb();
      final result = _localDb.rawDb.select(
        'SELECT * FROM pomodoro_sessions WHERE linkedTaskId = ? ORDER BY startTime DESC',
        [taskId],
      );
      return result.map((row) => PomodoroSession.fromDatabase(row)).toList();
    }
  }

  Future<void> saveSession(PomodoroSession session) async {
    if (_isRemote) {
      final collection = _firestoreService.pomodoroSessions;
      if (collection == null) return;

      await collection.doc(session.id).set(session.toFirestore());
    } else {
      await _ensureDb();
      final data = session.toDatabase();
      _localDb.rawDb.execute(
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
  }

  Future<void> deleteSession(String id) async {
    if (_isRemote) {
      final collection = _firestoreService.pomodoroSessions;
      if (collection == null) return;

      await collection.doc(id).delete();
    } else {
      await _ensureDb();
      _localDb.rawDb.execute('DELETE FROM pomodoro_sessions WHERE id = ?', [id]);
    }
  }

  Future<PomodoroStats> calculateStats() async {
    List<PomodoroSession> allSessions;

    if (_isRemote) {
      final collection = _firestoreService.pomodoroSessions;
      if (collection == null) return const PomodoroStats();

      final snapshot = await collection
          .where('completed', isEqualTo: true)
          .where('type', isEqualTo: PomodoroSessionType.work.name)
          .orderBy('startTime', descending: true)
          .get();

      allSessions = snapshot.docs.map((doc) {
        return PomodoroSession.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } else {
      await _ensureDb();
      final result = _localDb.rawDb.select(
        'SELECT * FROM pomodoro_sessions WHERE completed = 1 AND type = 0 ORDER BY startTime DESC',
      );
      allSessions = result.map((row) => PomodoroSession.fromDatabase(row)).toList();
    }

    if (allSessions.isEmpty) {
      return const PomodoroStats();
    }

    // Calculate totals
    int totalSessions = allSessions.length;
    int totalMinutes = 0;
    final dailySessions = <DateTime, int>{};

    for (final session in allSessions) {
      totalMinutes += session.durationMinutes;

      final date = session.startTime;
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
