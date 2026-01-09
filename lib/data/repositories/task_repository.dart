import 'dart:convert';
import 'package:dayflow/models/task_model.dart';
import 'package:dayflow/models/recurrence_model.dart';
import 'package:dayflow/services/mixpanel_service.dart';
import 'package:dayflow/services/firestore_service.dart';
import 'package:dayflow/services/backend_api_service.dart';
import 'package:dayflow/services/sync_status_service.dart';
import '../local/app_database.dart';

class TaskRepository {
  final AppDatabase _localDb;
  final FirestoreService _firestoreService;
  final BackendApiService? _api;
  final SyncStatusService _syncStatus = SyncStatusService();

  // Prevent duplicate sync calls
  bool _isSyncing = false;
  DateTime? _lastSyncTime;

  TaskRepository(this._localDb, this._firestoreService,
      {BackendApiService? api})
      : _api = api;

  /// Check if backend API sync is available
  bool get _useBackend =>
      _api != null && _firestoreService.currentUserId != null;

  /// Check if Firestore sync is available
  bool get _useFirestore => _firestoreService.currentUserId != null;

  Future<void> _ensureDb() async => _localDb.init();

  Future<void> _upsertTaskFirestore(Task task) async {
    final col = _firestoreService.tasks;
    if (col == null) return;
    await col.doc(task.id).set(task.toFirestore());
  }

  Future<void> _deleteTaskFirestore(String id) async {
    final col = _firestoreService.tasks;
    if (col == null) return;
    await col.doc(id).delete();
  }

  Future<void> _cacheTasksLocal(List<Task> tasks) async {
    await _ensureDb();
    _localDb.rawDb.execute('DELETE FROM subtasks');
    _localDb.rawDb.execute('DELETE FROM tasks');
    for (final task in tasks) {
      await _saveTaskLocal(task);
    }
  }

  Future<List<Task>> _fetchTasksLocal() async {
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
        createdAt: DateTime.fromMillisecondsSinceEpoch(row['createdAt'] as int),
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

  Future<void> _saveTaskLocal(Task task) async {
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

  Future<void> _deleteTaskLocal(String id) async {
    await _ensureDb();
    _localDb.rawDb.execute('DELETE FROM tasks WHERE id = ?', [id]);

    MixpanelService.instance.trackEvent("Task Deleted", {
      "task_id": id,
    });
  }

  Future<void> _toggleTaskCompletionLocal(String id) async {
    await _ensureDb();
    final before = _localDb.rawDb.select(
        'SELECT isCompleted FROM tasks WHERE id = ?',
        [id]).first['isCompleted'] as int;

    _localDb.rawDb.execute(
      'UPDATE tasks SET isCompleted = CASE WHEN isCompleted = 1 THEN 0 ELSE 1 END WHERE id = ?',
      [id],
    );

    final completed = before == 0;

    MixpanelService.instance.trackEvent(
      completed ? "Task Completed" : "Task Uncompleted",
      {
        "task_id": id,
      },
    );
  }

  Future<void> _toggleSubtaskLocal(String taskId, String subtaskId) async {
    await _ensureDb();

    final before = _localDb.rawDb.select(
        'SELECT isCompleted FROM subtasks WHERE id = ?',
        [subtaskId]).first['isCompleted'] as int;

    _localDb.rawDb.execute(
      'UPDATE subtasks SET isCompleted = CASE WHEN isCompleted = 1 THEN 0 ELSE 1 END WHERE id = ?',
      [subtaskId],
    );

    final completed = before == 0;

    MixpanelService.instance.trackEvent(
      completed ? "Subtask Completed" : "Subtask Uncompleted",
      {
        "task_id": taskId,
        "subtask_id": subtaskId,
      },
    );
  }

  /// LOCAL-FIRST approach: Always return local data immediately,
  Future<List<Task>> fetchTasks() async {
    print('📋 TaskRepository.fetchTasks() - LOCAL FIRST');

    final localTasks = await _fetchTasksLocal();
    print('📋 Got ${localTasks.length} tasks from local DB');

    if (_useBackend && !_isSyncing) {
      final now = DateTime.now();
      if (_lastSyncTime == null ||
          now.difference(_lastSyncTime!).inSeconds > 5) {
        _syncFromBackend();
      }
    }

    return localTasks;
  }

  Future<void> _syncFromBackend() async {
    if (_isSyncing) return;

    _isSyncing = true;
    _lastSyncTime = DateTime.now();
    _syncStatus.startSync('tasks');

    try {
      print('📋 Background sync: fetching from backend...');
      final tasks = await _api!.fetchTasks();
      print('✅ Background sync: got ${tasks.length} tasks from backend');
      await _cacheTasksLocal(tasks);
      _syncStatus.endSync('tasks', success: true);
    } catch (e) {
      print('⚠️ Background sync failed (will use local): $e');
      _syncStatus.endSync('tasks', success: false);
    } finally {
      _isSyncing = false;
    }
  }

  /// LOCAL-FIRST: Save locally immediately, sync to backend in background
  Future<void> upsertTask(Task task) async {
    print('📋 TaskRepository.upsertTask() - LOCAL FIRST');

    await _saveTaskLocal(task);
    print('✅ Task saved to local DB: ${task.id}');

    if (_useFirestore) {
      _syncTaskToFirestore(task);
    }

    if (_useBackend) {
      _syncTaskToBackendApi(task);
    }
  }

  Future<void> _syncTaskToFirestore(Task task) async {
    try {
      await _upsertTaskFirestore(task);
      print('✅ Task synced to Firestore: ${task.id}');
    } catch (e) {
      print('⚠️ Firestore sync failed: $e');
    }
  }

  Future<void> _syncTaskToBackendApi(Task task) async {
    try {
      print('📋 Background sync: saving task to backend...');
      await _api!.saveTask(task);
      print('✅ Background sync: task saved to backend');
    } catch (e) {
      print('⚠️ Background sync to backend failed: $e');
    }
  }

  /// LOCAL-FIRST: Delete locally immediately, sync in background
  Future<void> deleteTask(String id) async {
    print('📋 TaskRepository.deleteTask() - LOCAL FIRST');

    await _deleteTaskLocal(id);
    print('✅ Task deleted from local DB: $id');

    if (_useFirestore) {
      _deleteTaskFromFirestore(id);
    }

    if (_useBackend) {
      _deleteTaskFromBackendApi(id);
    }
  }

  Future<void> _deleteTaskFromFirestore(String id) async {
    try {
      await _deleteTaskFirestore(id);
      print('✅ Task deleted from Firestore: $id');
    } catch (e) {
      print('⚠️ Firestore delete failed: $e');
    }
  }

  Future<void> _deleteTaskFromBackendApi(String id) async {
    try {
      await _api!.deleteTask(id);
      print('✅ Background: task deleted from backend');
    } catch (e) {
      print('⚠️ Background delete from backend failed: $e');
    }
  }

  /// LOCAL-FIRST: Toggle locally immediately, sync in background
  Future<void> toggleTaskCompletion(String id) async {
    print('📋 TaskRepository.toggleTaskCompletion() - LOCAL FIRST');

    await _toggleTaskCompletionLocal(id);
    print('✅ Task toggled in local DB: $id');

    if (_useFirestore) {
      _syncToggleToFirestore(id);
    }

    if (_useBackend) {
      _toggleTaskCompletionBackendApi(id);
    }
  }

  Future<void> _syncToggleToFirestore(String id) async {
    try {
      final localTasks = await _fetchTasksLocal();
      final task = localTasks.firstWhere((t) => t.id == id,
          orElse: () => throw Exception('Task not found'));
      await _upsertTaskFirestore(task);
      print('✅ Task completion synced to Firestore');
    } catch (e) {
      print('⚠️ Firestore sync failed: $e');
    }
  }

  Future<void> _toggleTaskCompletionBackendApi(String id) async {
    try {
      final updated = await _api!.toggleTaskCompletion(id);
      await _saveTaskLocal(updated);
      print('✅ Background: task completion synced to backend');
    } catch (e) {
      print('⚠️ Background toggle sync failed: $e');
    }
  }

  /// LOCAL-FIRST: Toggle subtask locally immediately, sync in background
  Future<void> toggleSubtask(String taskId, String subtaskId) async {
    print('📋 TaskRepository.toggleSubtask() - LOCAL FIRST');

    await _toggleSubtaskLocal(taskId, subtaskId);
    print('✅ Subtask toggled in local DB');

    if (_useFirestore) {
      _syncSubtaskToFirestore(taskId);
    }

    if (_useBackend) {
      _toggleSubtaskBackendApi(taskId, subtaskId);
    }
  }

  Future<void> _syncSubtaskToFirestore(String taskId) async {
    try {
      final localTasks = await _fetchTasksLocal();
      final task = localTasks.firstWhere((t) => t.id == taskId,
          orElse: () => throw Exception('Task not found'));
      await _upsertTaskFirestore(task);
      print('✅ Subtask synced to Firestore');
    } catch (e) {
      print('⚠️ Firestore sync failed: $e');
    }
  }

  Future<void> _toggleSubtaskBackendApi(String taskId, String subtaskId) async {
    try {
      final updated = await _api!.toggleSubtask(taskId, subtaskId);
      await _saveTaskLocal(updated);
      print('✅ Background: subtask synced to backend');
    } catch (e) {
      print('⚠️ Background subtask sync failed: $e');
    }
  }

  AppDatabase get localDb => _localDb;

  Future<void> syncLocalDataToFirestore() async {
    if (!_useFirestore) {
      print('⚠️ Cannot sync: user not logged in');
      return;
    }

    print('🔄 TaskRepository: Syncing local data to Firestore...');

    try {
      final localTasks = await _fetchTasksLocal();
      if (localTasks.isEmpty) {
        print('📋 No local tasks to sync');
        return;
      }

      final col = _firestoreService.tasks;
      if (col == null) return;

      final existingDocs = await col.get();
      final existingIds = existingDocs.docs.map((doc) => doc.id).toSet();

      int syncedCount = 0;
      for (final task in localTasks) {
        if (!existingIds.contains(task.id)) {
          await col.doc(task.id).set(task.toFirestore());
          syncedCount++;
        }
      }

      print(
          '✅ Synced $syncedCount new tasks to Firestore (${localTasks.length - syncedCount} already existed)');
    } catch (e) {
      print('⚠️ Error syncing local tasks to Firestore: $e');
    }
  }
}
