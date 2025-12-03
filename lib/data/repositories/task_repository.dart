import 'dart:convert';

import 'package:dayflow/models/task_model.dart';

import '../local/app_database.dart';

class TaskRepository {
  final AppDatabase _db;

  TaskRepository(this._db);

  Future<void> _ensureDb() async => _db.init();

  Future<List<Task>> fetchTasks() async {
    await _ensureDb();
    final taskResult = _db.rawDb.select('SELECT * FROM tasks');
    final subtaskResult = _db.rawDb.select('SELECT * FROM subtasks');

    return taskResult.map((row) {
      final relatedSubtasks = subtaskResult
          .where((s) => s['taskId'] == row['id'])
          .map((s) => Subtask(
                id: s['id'] as String,
                title: s['title'] as String,
                isCompleted: (s['isCompleted'] as int) == 1,
              ))
          .toList();

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
      );
    }).toList();
  }

  Future<void> upsertTask(Task task) async {
    await _ensureDb();
    _db.rawDb.execute(
      'INSERT OR REPLACE INTO tasks (id, title, description, isCompleted, createdAt, dueDate, priority, tagsJson) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      [
        task.id,
        task.title,
        task.description,
        task.isCompleted ? 1 : 0,
        task.createdAt.millisecondsSinceEpoch,
        task.dueDate?.millisecondsSinceEpoch,
        task.priority.index,
        task.tags != null ? jsonEncode(task.tags) : null,
      ],
    );

    _db.rawDb.execute('DELETE FROM subtasks WHERE taskId = ?', [task.id]);

    if (task.subtasks != null) {
      final stmt = _db.rawDb.prepare(
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

  Future<void> deleteTask(String id) async {
    await _ensureDb();
    _db.rawDb.execute('DELETE FROM tasks WHERE id = ?', [id]);
  }

  Future<void> toggleTaskCompletion(String id) async {
    await _ensureDb();
    _db.rawDb.execute(
      'UPDATE tasks SET isCompleted = CASE WHEN isCompleted = 1 THEN 0 ELSE 1 END WHERE id = ?',
      [id],
    );
  }

  Future<void> toggleSubtask(String taskId, String subtaskId) async {
    await _ensureDb();
    _db.rawDb.execute(
      'UPDATE subtasks SET isCompleted = CASE WHEN isCompleted = 1 THEN 0 ELSE 1 END WHERE id = ?',
      [subtaskId],
    );
  }
}
