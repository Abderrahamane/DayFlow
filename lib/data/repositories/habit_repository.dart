import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:dayflow/services/mixpanel_service.dart';
import 'package:dayflow/models/habit_model.dart';
import 'package:flutter/material.dart';
import 'package:dayflow/services/firestore_service.dart';

import '../local/app_database.dart';

class HabitRepository {
  final AppDatabase _localDb;
  final FirestoreService _firestoreService;

  HabitRepository(this._localDb, this._firestoreService);

  bool get _isRemote => _firestoreService.currentUserId != null;

  Future<void> _ensureDb() async => _localDb.init();

  Future<List<Habit>> fetchHabits() async {
    if (_isRemote) {
      final collection = _firestoreService.habits;
      if (collection == null) return [];

      try {
        final snapshot = await collection.get(const firestore.GetOptions(source: firestore.Source.serverAndCache));
        return snapshot.docs.map((doc) {
          return Habit.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      } catch (e) {
        try {
          final snapshot = await collection.get(const firestore.GetOptions(source: firestore.Source.cache));
          return snapshot.docs.map((doc) {
            return Habit.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();
        } catch (_) {
          return [];
        }
      }
    } else {
      await _ensureDb();
      final habitRows = _localDb.rawDb.select('SELECT * FROM habits');
      final completionRows = _localDb.rawDb.select('SELECT * FROM habit_completions');

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
  }

  Future<void> upsertHabit(Habit habit) async {
    if (_isRemote) {
      final collection = _firestoreService.habits;
      if (collection == null) return;

      final docRef = collection.doc(habit.id);
      final docSnapshot = await docRef.get();
      final isNew = !docSnapshot.exists;

      await docRef.set(habit.toFirestore());

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
    } else {
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
  }

  Future<void> toggleCompletion(String habitId, String dateKey) async {
    if (_isRemote) {
      final collection = _firestoreService.habits;
      if (collection == null) return;

      final docRef = collection.doc(habitId);
      final doc = await docRef.get();
      if (!doc.exists) return;

      final data = doc.data() as Map<String, dynamic>;
      final history = data['completionHistory'] != null
          ? Map<String, bool>.from(data['completionHistory'])
          : <String, bool>{};

      final current = history[dateKey] ?? false;
      final newState = !current;
      history[dateKey] = newState;

      await docRef.update({'completionHistory': history});

      MixpanelService.instance.trackEvent(
        newState ? "Habit Completion Added" : "Habit Completion Toggled",
        {
          "habit_id": habitId,
          "dateKey": dateKey,
          "new_state": newState,
        },
      );
    } else {
      await _ensureDb();

      final existing = _localDb.rawDb.select(
        'SELECT * FROM habit_completions WHERE habitId = ? AND dateKey = ?',
        [habitId, dateKey],
      );

      bool newState;

      if (existing.isEmpty) {
        _localDb.rawDb.execute(
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
  }

  Future<void> deleteHabit(String id) async {
    if (_isRemote) {
      final collection = _firestoreService.habits;
      if (collection == null) return;

      await collection.doc(id).delete();

      // Analytics
      MixpanelService.instance.trackEvent("Habit Deleted", {
        "habit_id": id,
      });
    } else {
      await _ensureDb();

      _localDb.rawDb.execute('DELETE FROM habits WHERE id = ?', [id]);

      // Analytics
      MixpanelService.instance.trackEvent("Habit Deleted", {
        "habit_id": id,
      });
    }
  }
}
