import 'dart:convert';
import 'package:dayflow/services/mixpanel_service.dart';
import 'package:dayflow/models/habit_model.dart';
import 'package:flutter/material.dart';

import '../local/app_database.dart';

class HabitRepository {
  final AppDatabase _db;

  HabitRepository(this._db);

  Future<void> _ensureDb() async => _db.init();

  Future<List<Habit>> fetchHabits() async {
    await _ensureDb();
    final habitRows = _db.rawDb.select('SELECT * FROM habits');
    final completionRows = _db.rawDb.select('SELECT * FROM habit_completions');

    return habitRows.map((row) {
      final history = <String, bool>{};
      for (final entry in completionRows.where((c) => c['habitId'] == row['id'])) {
        history[entry['dateKey'] as String] = (entry['isCompleted'] as int) == 1;
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
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(row['createdAt'] as int),
        color: Color(row['colorValue'] as int),
      );
    }).toList();
  }

  Future<void> upsertHabit(Habit habit) async {
    await _ensureDb();

    final isNew = _db.rawDb.select(
      'SELECT id FROM habits WHERE id = ?',
      [habit.id],
    ).isEmpty;

    _db.rawDb.execute(
      'INSERT OR REPLACE INTO habits (id, name, description, icon, frequency, goalCount, linkedTagsJson, createdAt, colorValue) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        habit.id,
        habit.name,
        habit.description,
        habit.icon,
        habit.frequency.index,
        habit.goalCount,
        habit.linkedTaskTags.isNotEmpty ? jsonEncode(habit.linkedTaskTags) : null,
        habit.createdAt.millisecondsSinceEpoch,
        habit.color.value,
      ],
    );

    // Analytics: Habit Created or Updated 
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

    // Handle completion history
    _db.rawDb.execute(
      'DELETE FROM habit_completions WHERE habitId = ?',
      [habit.id],
    );

    if (habit.completionHistory.isNotEmpty) {
      final stmt = _db.rawDb.prepare(
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

  Future<void> toggleCompletion(String habitId, String dateKey) async {
    await _ensureDb();

    final existing = _db.rawDb.select(
      'SELECT * FROM habit_completions WHERE habitId = ? AND dateKey = ?',
      [habitId, dateKey],
    );

    bool newState;

    if (existing.isEmpty) {
      _db.rawDb.execute(
        'INSERT INTO habit_completions (habitId, dateKey, isCompleted) VALUES (?, ?, 1)',
        [habitId, dateKey],
      );
      newState = true;

      MixpanelService.instance.trackEvent("Habit Completion Added", {
        "habit_id": habitId,
        "dateKey": dateKey,
      });
    } else {
      final current = existing.first['isCompleted'] == 1;
      newState = !current;

      _db.rawDb.execute(
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

  Future<void> deleteHabit(String id) async {
    await _ensureDb();

    _db.rawDb.execute('DELETE FROM habits WHERE id = ?', [id]);

    // Analytics
    MixpanelService.instance.trackEvent("Habit Deleted", {
      "habit_id": id,
    });
  }
}
