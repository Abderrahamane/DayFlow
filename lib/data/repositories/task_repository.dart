import 'package:dayflow/models/task_model.dart';
import 'package:dayflow/services/mixpanel_service.dart';
import 'package:dayflow/services/firestore_service.dart';

class TaskRepository {
  final FirestoreService _firestoreService;

  TaskRepository(this._firestoreService);

  Future<List<Task>> fetchTasks() async {
    final collection = _firestoreService.tasks;
    if (collection == null) return [];

    final snapshot = await collection.get();
    return snapshot.docs.map((doc) {
      return Task.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<void> upsertTask(Task task) async {
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
  }

  Future<void> deleteTask(String id) async {
    final collection = _firestoreService.tasks;
    if (collection == null) return;

    await collection.doc(id).delete();

    // Analytics
    MixpanelService.instance.trackEvent("Task Deleted", {
      "task_id": id,
    });
  }

  Future<void> toggleTaskCompletion(String id) async {
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
  }

  Future<void> toggleSubtask(String taskId, String subtaskId) async {
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
  }
}
