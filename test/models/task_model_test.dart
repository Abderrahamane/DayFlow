import 'package:flutter_test/flutter_test.dart';
import 'package:dayflow/models/task_model.dart';

void main() {
  group('Task Model', () {
    late Task task;
    late DateTime now;

    setUp(() {
      now = DateTime.now();
      task = Task(
        id: 'test-id',
        title: 'Test Task',
        description: 'Test Description',
        isCompleted: false,
        createdAt: now,
        dueDate: now.add(const Duration(days: 1)),
        priority: TaskPriority.high,
        tags: ['work', 'urgent'],
      );
    });

    test('should create a task with given properties', () {
      expect(task.id, 'test-id');
      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.isCompleted, false);
      expect(task.priority, TaskPriority.high);
      expect(task.tags, ['work', 'urgent']);
    });

    test('copyWith should create a new task with updated properties', () {
      final updatedTask = task.copyWith(
        title: 'Updated Title',
        isCompleted: true,
      );

      expect(updatedTask.title, 'Updated Title');
      expect(updatedTask.isCompleted, true);
      expect(updatedTask.id, task.id);
      expect(updatedTask.description, task.description);
    });

    test('isOverdue should return true for past due date', () {
      final overdueTask = task.copyWith(
        dueDate: now.subtract(const Duration(days: 1)),
        isCompleted: false,
      );

      expect(overdueTask.isOverdue, true);
    });

    test('isOverdue should return false for completed tasks', () {
      final completedTask = task.copyWith(
        dueDate: now.subtract(const Duration(days: 1)),
        isCompleted: true,
      );

      expect(completedTask.isOverdue, false);
    });

    test('isDueToday should return true for today due date', () {
      final todayTask = task.copyWith(
        dueDate: DateTime(now.year, now.month, now.day, 23, 59),
      );

      expect(todayTask.isDueToday, true);
    });

    test('daysRemaining should return correct number of days', () {
      final futureTask = task.copyWith(
        dueDate: DateTime(now.year, now.month, now.day).add(const Duration(days: 5)),
      );

      expect(futureTask.daysRemaining, 5);
    });

    test('toJson and fromJson should serialize correctly', () {
      final json = task.toJson();
      final fromJsonTask = Task.fromJson(json);

      expect(fromJsonTask.id, task.id);
      expect(fromJsonTask.title, task.title);
      expect(fromJsonTask.description, task.description);
      expect(fromJsonTask.isCompleted, task.isCompleted);
      expect(fromJsonTask.priority, task.priority);
      expect(fromJsonTask.tags, task.tags);
    });

    test('hasSubtasks should return false when no subtasks', () {
      expect(task.hasSubtasks, false);
    });

    test('hasSubtasks should return true when subtasks exist', () {
      final taskWithSubtasks = task.copyWith(
        subtasks: [
          Subtask(id: 's1', title: 'Subtask 1'),
          Subtask(id: 's2', title: 'Subtask 2', isCompleted: true),
        ],
      );

      expect(taskWithSubtasks.hasSubtasks, true);
      expect(taskWithSubtasks.totalSubtasks, 2);
      expect(taskWithSubtasks.completedSubtasks, 1);
    });
  });

  group('Subtask Model', () {
    test('should create a subtask with default values', () {
      final subtask = Subtask(id: 'sub-1', title: 'Subtask');

      expect(subtask.id, 'sub-1');
      expect(subtask.title, 'Subtask');
      expect(subtask.isCompleted, false);
    });

    test('copyWith should update isCompleted', () {
      final subtask = Subtask(id: 'sub-1', title: 'Subtask');
      final completed = subtask.copyWith(isCompleted: true);

      expect(completed.isCompleted, true);
      expect(completed.title, subtask.title);
    });
  });

  group('TaskPriority', () {
    test('should have correct priority values', () {
      expect(TaskPriority.values.length, 4);
      expect(TaskPriority.values.contains(TaskPriority.none), true);
      expect(TaskPriority.values.contains(TaskPriority.low), true);
      expect(TaskPriority.values.contains(TaskPriority.medium), true);
      expect(TaskPriority.values.contains(TaskPriority.high), true);
    });
  });
}

