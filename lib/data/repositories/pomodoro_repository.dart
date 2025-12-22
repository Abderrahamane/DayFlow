import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
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

    if (_isRemote) {
      try {
        final doc = await _firestoreService.users.doc(_firestoreService.currentUserId).get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data() as Map<String, dynamic>;
          if (data.containsKey('pomodoroSettings')) {
            final settings = PomodoroSettings.fromJson(data['pomodoroSettings']);
            // Update local cache
            await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
            return settings;
          }
        }
      } catch (e) {
        // Fallback to local if remote fails
      }
    }

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
    final json = settings.toJson();
    await prefs.setString(_settingsKey, jsonEncode(json));

    if (_isRemote) {
      try {
        await _firestoreService.users.doc(_firestoreService.currentUserId).set({
          'pomodoroSettings': json,
        }, SetOptions(merge: true));
      } catch (e) {
        // Ignore remote save errors
      }
    }
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
          .get();

      final sessions = snapshot.docs.map((doc) {
        return PomodoroSession.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
      return sessions;
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
          .where('type', isEqualTo: PomodoroSessionType.work.name)
          .get();

      allSessions = snapshot.docs.map((doc) {
        return PomodoroSession.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      allSessions.sort((a, b) => b.startTime.compareTo(a.startTime));
    } else {
      await _ensureDb();
      final result = _localDb.rawDb.select(
        'SELECT * FROM pomodoro_sessions WHERE type = 0 ORDER BY startTime DESC',
      );
      allSessions = result.map((row) => PomodoroSession.fromDatabase(row)).toList();
    }

    if (allSessions.isEmpty) {
      return const PomodoroStats();
    }

    // Calculate totals
    int totalSessions = 0;
    int totalMinutes = 0;
    final dailySessions = <DateTime, int>{};

    for (final session in allSessions) {
      int duration;
      if (session.completed) {
        duration = session.durationMinutes;
        totalSessions++;

        final date = session.startTime;
        final dateOnly = DateTime(date.year, date.month, date.day);
        dailySessions[dateOnly] = (dailySessions[dateOnly] ?? 0) + 1;
      } else {
        // For incomplete sessions, calculate actual duration
        duration = session.actualDurationSeconds ~/ 60;
      }

      totalMinutes += duration;
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
