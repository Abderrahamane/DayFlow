import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:dayflow/models/task_model.dart';
import 'package:dayflow/models/recurrence_model.dart';
import 'package:dayflow/services/mixpanel_service.dart';
import 'package:dayflow/services/firestore_service.dart';
import '../local/app_database.dart';

class TaskRepository {
  final AppDatabase _localDb;
  final FirestoreService _firestoreService;

  TaskRepository(this._localDb, this._firestoreService);

  bool get _isRemote => _firestoreService.currentUserId != null;

  Future<void> _ensureDb() async => _localDb.init();

  Future<List<Task>> fetchTasks() async {
    if (_isRemote) {
      final collection = _firestoreService.tasks;
      if (collection == null) return [];

      try {
        final snapshot = await collection.get(const firestore.GetOptions(source: firestore.Source.serverAndCache));
        return snapshot.docs.map((doc) {
          return Task.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      } catch (e) {
        // Fallback to cache if server fails
        try {
          final snapshot = await collection.get(const firestore.GetOptions(source: firestore.Source.cache));
          return snapshot.docs.map((doc) {
            return Task.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();
        } catch (_) {
          return [];
        }
      }
    } else {
      await _ensureDb();
      final taskResult = _localDb.rawDb.select('SELECT * FROM tasks');
      final subtaskResult = _localDb.rawDb.select('SELECT * FROM subtasks');

      return taskResult.map((row) {
        final relatedSubtasks = subtaskResult
            .where((s) => s['taskId'] == row['id'])
            .map((s) => Subtask(
                  id: s['id'] as String,
                  title: s['title'] as String,
                  isCompleted: (s['isCompleted'] as int) == 1,
                ))
            .toList();

        final recurrenceData = row['recurrenceData'] as String?;

        return Task(
          id: row['id'] as String,
          title: row['title'] as String,
          description: row['description'] as String?,
          isCompleted: (row['isCompleted'] as int) == 1,
          createdAt:
              DateTime.fromMillisecondsSinceEpoch(row['createdAt'] as int),
          dueDate: row['dueDate'] != null
              ? DateTime.fromMillisecondsSinceEpoch(row['dueDate'] as int)
              : null,
          priority: TaskPriority.values[row['priority'] as int],
          tags: row['tagsJson'] != null
              ? List<String>.from(jsonDecode(row['tagsJson'] as String))
              : null,
          subtasks: relatedSubtasks.isEmpty ? null : relatedSubtasks,
          recurrence: recurrenceData != null && recurrenceData.isNotEmpty
              ? RecurrencePattern.fromDatabase(recurrenceData)
              : null,
          parentTaskId: row['parentTaskId'] as String?,
        );
      }).toList();
    }
  }

  Future<void> upsertTask(Task task) async {
    if (_isRemote) {
      final collection = _firestoreService.tasks;
      if (collection == null) return;

      final docRef = collection.doc(task.id);
      final docSnapshot = await docRef.get();
      final isNew = !docSnapshot.exists;

      await docRef.set(task.toFirestore());

      // Analytics Call
      MixpanelService.instance.trackEvent(
        isNew ? "Task Created" : "Task Updated",
        {
          "task_id": task.id,
          "title": task.title,
          "priority": task.priority.toString(),
          "has_due_date": task.dueDate != null,
          "tags_count": task.tags?.length ?? 0,
          "subtasks_count": task.subtasks?.length ?? 0,
        },
      );
    } else {
      await _ensureDb();

      final isNew = _localDb.rawDb
          .select('SELECT id FROM tasks WHERE id = ?', [task.id]).isEmpty;

      _localDb.rawDb.execute(
        'INSERT OR REPLACE INTO tasks (id, title, description, isCompleted, createdAt, dueDate, priority, tagsJson, recurrenceData, parentTaskId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          task.id,
          task.title,
          task.description,
          task.isCompleted ? 1 : 0,
          task.createdAt.millisecondsSinceEpoch,
          task.dueDate?.millisecondsSinceEpoch,
          task.priority.index,
          task.tags != null ? jsonEncode(task.tags) : null,
          task.recurrence?.toDatabase(),
          task.parentTaskId,
        ],
      );

      // Analytics Call
      MixpanelService.instance.trackEvent(
        isNew ? "Task Created" : "Task Updated",
        {
          "task_id": task.id,
          "title": task.title,
          "priority": task.priority.toString(),
          "has_due_date": task.dueDate != null,
          "tags_count": task.tags?.length ?? 0,
          "subtasks_count": task.subtasks?.length ?? 0,
        },
      );

      // Handle subtasks
      _localDb.rawDb.execute('DELETE FROM subtasks WHERE taskId = ?', [task.id]);

      if (task.subtasks != null) {
        final stmt = _localDb.rawDb.prepare(
          'INSERT OR REPLACE INTO subtasks (id, taskId, title, isCompleted) VALUES (?, ?, ?, ?)',
        );
        for (final subtask in task.subtasks!) {
          stmt.execute([
            subtask.id,
            task.id,
            subtask.title,
            subtask.isCompleted ? 1 : 0,
          ]);
        }
        stmt.dispose();
      }
    }
  }

  Future<void> deleteTask(String id) async {
    if (_isRemote) {
      final collection = _firestoreService.tasks;
      if (collection == null) return;

      await collection.doc(id).delete();

      // Analytics
      MixpanelService.instance.trackEvent("Task Deleted", {
        "task_id": id,
      });
    } else {
      await _ensureDb();

      _localDb.rawDb.execute('DELETE FROM tasks WHERE id = ?', [id]);

      // Analytics
      MixpanelService.instance.trackEvent("Task Deleted", {
        "task_id": id,
      });
    }
  }

  Future<void> toggleTaskCompletion(String id) async {
    if (_isRemote) {
      final collection = _firestoreService.tasks;
      if (collection == null) return;

      final docRef = collection.doc(id);
      final doc = await docRef.get();
      if (!doc.exists) return;

      final data = doc.data() as Map<String, dynamic>;
      final currentStatus = data['isCompleted'] as bool? ?? false;
      final newStatus = !currentStatus;

      await docRef.update({'isCompleted': newStatus});

      // ✅ Correct Analytics
      MixpanelService.instance.trackEvent(
        newStatus ? "Task Completed" : "Task Uncompleted",
        {
          "task_id": id,
        },
      );
    } else {
      await _ensureDb();
      final before = _localDb.rawDb
          .select('SELECT isCompleted FROM tasks WHERE id = ?', [id])
          .first['isCompleted'] as int;

      _localDb.rawDb.execute(
        'UPDATE tasks SET isCompleted = CASE WHEN isCompleted = 1 THEN 0 ELSE 1 END WHERE id = ?',
        [id],
      );

      final completed = before == 0;

      // ✅ Correct Analytics
      MixpanelService.instance.trackEvent(
        completed ? "Task Completed" : "Task Uncompleted",
        {
          "task_id": id,
        },
      );
    }
  }

  Future<void> toggleSubtask(String taskId, String subtaskId) async {
    if (_isRemote) {
      final collection = _firestoreService.tasks;
      if (collection == null) return;

      final docRef = collection.doc(taskId);
      final doc = await docRef.get();
      if (!doc.exists) return;

      final task = Task.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      if (task.subtasks == null) return;

      final updatedSubtasks = task.subtasks!.map((s) {
        if (s.id == subtaskId) {
          return s.copyWith(isCompleted: !s.isCompleted);
        }
        return s;
      }).toList();

      final updatedTask = task.copyWith(subtasks: updatedSubtasks);
      await docRef.set(updatedTask.toFirestore());

      final subtask = updatedSubtasks.firstWhere((s) => s.id == subtaskId);

      // Analytics
      MixpanelService.instance.trackEvent(
        subtask.isCompleted ? "Subtask Completed" : "Subtask Uncompleted",
        {
          "task_id": taskId,
          "subtask_id": subtaskId,
        },
      );
    } else {
      await _ensureDb();

      final before = _localDb.rawDb
          .select('SELECT isCompleted FROM subtasks WHERE id = ?', [subtaskId])
          .first['isCompleted'] as int;

      _localDb.rawDb.execute(
        'UPDATE subtasks SET isCompleted = CASE WHEN isCompleted = 1 THEN 0 ELSE 1 END WHERE id = ?',
        [subtaskId],
      );

      final completed = before == 0;

      // Analytics
      MixpanelService.instance.trackEvent(
        completed ? "Subtask Completed" : "Subtask Uncompleted",
        {
          "task_id": taskId,
          "subtask_id": subtaskId,
        },
      );
    }
  }
}
