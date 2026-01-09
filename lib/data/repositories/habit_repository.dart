import 'dart:convert';
import 'package:dayflow/services/mixpanel_service.dart';
import 'package:dayflow/models/habit_model.dart';
import 'package:flutter/material.dart';
import 'package:dayflow/services/firestore_service.dart';
import 'package:dayflow/services/backend_api_service.dart';
import 'package:dayflow/services/sync_status_service.dart';

import '../local/app_database.dart';

class HabitRepository {
  final AppDatabase _localDb;
  final FirestoreService _firestoreService;
  final BackendApiService? _api;
  final SyncStatusService _syncStatus = SyncStatusService();

  // Prevent duplicate sync calls
  bool _isSyncing = false;
  DateTime? _lastSyncTime;

  HabitRepository(this._localDb, this._firestoreService,
      {BackendApiService? api})
      : _api = api;

  /// Check if backend API sync is available
  bool get _useBackend =>
      _api != null && _firestoreService.currentUserId != null;

  /// Check if Firestore sync is available (just needs logged in user)
  bool get _useFirestore => _firestoreService.currentUserId != null;

  Future<void> _ensureDb() async => _localDb.init();

  Future<void> _upsertHabitFirestore(Habit habit) async {
    final col = _firestoreService.habits;
    if (col == null) return;
    await col.doc(habit.id).set(habit.toFirestore());
  }

  Future<void> _deleteHabitFirestore(String id) async {
    final col = _firestoreService.habits;
    if (col == null) return;
    await col.doc(id).delete();
  }

  Future<void> _cacheHabitsLocal(List<Habit> habits) async {
    await _ensureDb();
    _localDb.rawDb.execute('DELETE FROM habit_completions');
    _localDb.rawDb.execute('DELETE FROM habits');
    for (final habit in habits) {
      await _saveHabitLocal(habit);
    }
  }

  Future<List<Habit>> _fetchHabitsLocal() async {
    await _ensureDb();
    final habitRows = _localDb.rawDb.select('SELECT * FROM habits');
    final completionRows =
        _localDb.rawDb.select('SELECT * FROM habit_completions');

    return habitRows.map((row) {
      final history = <String, bool>{};
      for (final entry
          in completionRows.where((c) => c['habitId'] == row['id'])) {
        history[entry['dateKey'] as String] =
            (entry['isCompleted'] as int) == 1;
      }

      return Habit(
        id: row['id'] as String,
        name: row['name'] as String,
        description: row['description'] as String?,
        icon: row['icon'] as String,
        frequency: HabitFrequency.values[row['frequency'] as int],
        goalCount: row['goalCount'] as int,
        linkedTaskTags: row['linkedTagsJson'] != null
            ? List<String>.from(jsonDecode(row['linkedTagsJson'] as String))
            : const [],
        completionHistory: history,
        createdAt: DateTime.fromMillisecondsSinceEpoch(row['createdAt'] as int),
        color: Color(row['colorValue'] as int),
      );
    }).toList();
  }

  Future<void> _saveHabitLocal(Habit habit) async {
    await _ensureDb();

    final isNew = _localDb.rawDb.select(
      'SELECT id FROM habits WHERE id = ?',
      [habit.id],
    ).isEmpty;

    _localDb.rawDb.execute(
      'INSERT OR REPLACE INTO habits (id, name, description, icon, frequency, goalCount, linkedTagsJson, createdAt, colorValue) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        habit.id,
        habit.name,
        habit.description,
        habit.icon,
        habit.frequency.index,
        habit.goalCount,
        habit.linkedTaskTags.isNotEmpty
            ? jsonEncode(habit.linkedTaskTags)
            : null,
        habit.createdAt.millisecondsSinceEpoch,
        habit.color.value,
      ],
    );

    if (isNew) {
      MixpanelService.instance.trackEvent("Habit Created", {
        "habit_id": habit.id,
        "name": habit.name,
        "frequency": habit.frequency.name,
        "goalCount": habit.goalCount,
        "createdAt": habit.createdAt.toIso8601String(),
      });
    } else {
      MixpanelService.instance.trackEvent("Habit Updated", {
        "habit_id": habit.id,
        "name": habit.name,
        "frequency": habit.frequency.name,
        "goalCount": habit.goalCount,
      });
    }

    _localDb.rawDb.execute(
      'DELETE FROM habit_completions WHERE habitId = ?',
      [habit.id],
    );

    if (habit.completionHistory.isNotEmpty) {
      final stmt = _localDb.rawDb.prepare(
        'INSERT OR REPLACE INTO habit_completions (habitId, dateKey, isCompleted) VALUES (?, ?, ?)',
      );
      for (final entry in habit.completionHistory.entries) {
        stmt.execute([
          habit.id,
          entry.key,
          entry.value ? 1 : 0,
        ]);
      }
      stmt.dispose();
    }
  }

  Future<void> _toggleCompletionLocal(String habitId, String dateKey) async {
    await _ensureDb();

    final existing = _localDb.rawDb.select(
      'SELECT * FROM habit_completions WHERE habitId = ? AND dateKey = ?',
      [habitId, dateKey],
    );

    if (existing.isEmpty) {
      _localDb.rawDb.execute(
        'INSERT INTO habit_completions (habitId, dateKey, isCompleted) VALUES (?, ?, 1)',
        [habitId, dateKey],
      );
      MixpanelService.instance.trackEvent("Habit Completion Added", {
        "habit_id": habitId,
        "dateKey": dateKey,
      });
    } else {
      final current = existing.first['isCompleted'] == 1;
      final newState = !current;

      _localDb.rawDb.execute(
        'UPDATE habit_completions SET isCompleted = ? WHERE habitId = ? AND dateKey = ?',
        [newState ? 1 : 0, habitId, dateKey],
      );

      MixpanelService.instance.trackEvent("Habit Completion Toggled", {
        "habit_id": habitId,
        "dateKey": dateKey,
        "new_state": newState,
      });
    }
  }

  Future<void> _deleteHabitLocal(String id) async {
    await _ensureDb();

    _localDb.rawDb.execute('DELETE FROM habits WHERE id = ?', [id]);

    MixpanelService.instance.trackEvent("Habit Deleted", {
      "habit_id": id,
    });
  }

  /// LOCAL-FIRST: Return local data immediately, sync in background
  Future<List<Habit>> fetchHabits() async {
    print('📊 HabitRepository.fetchHabits() - LOCAL FIRST');

    // Always fetch from local first for instant UI
    final localHabits = await _fetchHabitsLocal();
    print('📊 Got ${localHabits.length} habits from local DB');

    // Try to sync with backend in background (with debouncing)
    if (_useBackend && !_isSyncing) {
      final now = DateTime.now();
      if (_lastSyncTime == null ||
          now.difference(_lastSyncTime!).inSeconds > 5) {
        _syncHabitsFromBackend();
      }
    }

    return localHabits;
  }

  Future<void> _syncHabitsFromBackend() async {
    if (_isSyncing) return;

    _isSyncing = true;
    _lastSyncTime = DateTime.now();
    _syncStatus.startSync('habits');

    try {
      print('📊 Background sync: fetching habits from backend...');
      final habits = await _api!.fetchHabits();
      print('✅ Background sync: got ${habits.length} habits');
      await _cacheHabitsLocal(habits);
      _syncStatus.endSync('habits', success: true);
    } catch (e) {
      print('⚠️ Background habit sync failed: $e');
      _syncStatus.endSync('habits', success: false);
      // Silent failure - we already have local data
    } finally {
      _isSyncing = false;
    }
  }

  /// LOCAL-FIRST: Save locally immediately, sync in background
  Future<void> upsertHabit(Habit habit) async {
    print('📊 HabitRepository.upsertHabit() - LOCAL FIRST');

    // Save locally FIRST - instant UI response
    await _saveHabitLocal(habit);
    print('✅ Habit saved to local DB: ${habit.id}');

    // Sync to Firestore (works without backend API)
    if (_useFirestore) {
      _syncHabitToFirestore(habit);
    }

    // Sync to backend API in background (optional)
    if (_useBackend) {
      _syncHabitToBackendApi(habit);
    }
  }

  Future<void> _syncHabitToFirestore(Habit habit) async {
    try {
      await _upsertHabitFirestore(habit);
      print('✅ Habit synced to Firestore: ${habit.id}');
    } catch (e) {
      print('⚠️ Firestore sync failed: $e');
    }
  }

  Future<void> _syncHabitToBackendApi(Habit habit) async {
    try {
      await _api!.saveHabit(habit);
      print('✅ Background: habit synced to backend');
    } catch (e) {
      print('⚠️ Background habit sync failed: $e');
    }
  }

  /// LOCAL-FIRST: Toggle locally immediately, sync in background
  Future<void> toggleCompletion(String habitId, String dateKey) async {
    print('📊 HabitRepository.toggleCompletion() - LOCAL FIRST');

    // Toggle locally FIRST - instant UI response
    await _toggleCompletionLocal(habitId, dateKey);
    print('✅ Habit toggled in local DB');

    // Sync to Firestore (works without backend API)
    if (_useFirestore) {
      _syncToggleToFirestore(habitId);
    }

    // Sync to backend API in background (optional)
    if (_useBackend) {
      _toggleCompletionBackendApi(habitId, dateKey);
    }
  }

  Future<void> _syncToggleToFirestore(String habitId) async {
    try {
      final localHabits = await _fetchHabitsLocal();
      final habit = localHabits.firstWhere((h) => h.id == habitId,
          orElse: () => throw Exception('Habit not found'));
      await _upsertHabitFirestore(habit);
      print('✅ Habit completion synced to Firestore');
    } catch (e) {
      print('⚠️ Firestore sync failed: $e');
    }
  }

  Future<void> _toggleCompletionBackendApi(
      String habitId, String dateKey) async {
    try {
      final updated = await _api!.toggleHabitCompletion(habitId, dateKey);
      await _saveHabitLocal(updated);
      print('✅ Background: habit completion synced');
    } catch (e) {
      print('⚠️ Background toggle sync failed: $e');
    }
  }

  /// LOCAL-FIRST: Delete locally immediately, sync in background
  Future<void> deleteHabit(String id) async {
    print('📊 HabitRepository.deleteHabit() - LOCAL FIRST');

    // Delete locally FIRST - instant UI response
    await _deleteHabitLocal(id);
    print('✅ Habit deleted from local DB');

    // Sync to Firestore (works without backend API)
    if (_useFirestore) {
      _deleteHabitFromFirestore(id);
    }

    // Sync to backend API in background (optional)
    if (_useBackend) {
      _deleteHabitFromBackendApi(id);
    }
  }

  Future<void> _deleteHabitFromFirestore(String id) async {
    try {
      await _deleteHabitFirestore(id);
      print('✅ Habit deleted from Firestore: $id');
    } catch (e) {
      print('⚠️ Firestore delete failed: $e');
    }
  }

  Future<void> _deleteHabitFromBackendApi(String id) async {
    try {
      await _api!.deleteHabit(id);
      print('✅ Background: habit deleted from backend');
    } catch (e) {
      print('⚠️ Background delete failed: $e');
    }
  }

  /// Sync all local habits to Firestore (for first-time sync when user logs in)
  /// This checks if data exists in Firestore before adding to avoid duplicates
  Future<void> syncLocalDataToFirestore() async {
    if (!_useFirestore) {
      print('⚠️ Cannot sync: user not logged in');
      return;
    }

    print('🔄 HabitRepository: Syncing local data to Firestore...');

    try {
      final localHabits = await _fetchHabitsLocal();
      if (localHabits.isEmpty) {
        print('📊 No local habits to sync');
        return;
      }

      final col = _firestoreService.habits;
      if (col == null) return;

      // Get existing Firestore habit IDs to avoid duplicates
      final existingDocs = await col.get();
      final existingIds = existingDocs.docs.map((doc) => doc.id).toSet();

      int syncedCount = 0;
      for (final habit in localHabits) {
        if (!existingIds.contains(habit.id)) {
          await col.doc(habit.id).set(habit.toFirestore());
          syncedCount++;
        }
      }

      print(
          '✅ Synced $syncedCount new habits to Firestore (${localHabits.length - syncedCount} already existed)');
    } catch (e) {
      print('⚠️ Error syncing local habits to Firestore: $e');
    }
  }
}
