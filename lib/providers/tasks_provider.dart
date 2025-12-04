// // lib/providers/tasks_provider.dart
//
// import 'package:flutter/foundation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../models/task_model.dart';
// import '../services/mixpanel_service.dart';
//
// /// TasksProvider - Manages task state with Firestore integration
// ///
// /// This provider handles all task-related operations including:
// /// - Fetching tasks from Firestore
// /// - Creating new tasks
// /// - Updating existing tasks
// /// - Deleting tasks
// /// - Filtering and sorting tasks
// ///
// /// Usage:
// /// ```dart
// /// final tasksProvider = Provider.of<TasksProvider>(context);
// /// tasksProvider.addTask(newTask);
// /// ```
// class TasksProvider extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   List<Task> _tasks = [];
//   TaskFilter _currentFilter = TaskFilter.all;
//   TaskSort _currentSort = TaskSort.dateCreated;
//   bool _isLoading = false;
//   String? _error;
//
//   // Getters
//   List<Task> get tasks => _getFilteredAndSortedTasks();
//   List<Task> get allTasks => _tasks;
//   TaskFilter get currentFilter => _currentFilter;
//   TaskSort get currentSort => _currentSort;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//
//   int get totalTasks => _tasks.length;
//   int get completedTasks => _tasks.where((t) => t.isCompleted).length;
//   int get pendingTasks => _tasks.where((t) => !t.isCompleted).length;
//   int get overdueTasks => _tasks.where((t) => t.isOverdue).length;
//
//   /// Initialize and load tasks from Firestore
//   Future<void> loadTasks() async {
//     final user = _auth.currentUser;
//     if (user == null) {
//       _error = 'No user logged in';
//       notifyListeners();
//       return;
//     }
//
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       final snapshot = await _firestore
//           .collection('users')
//           .doc(user.uid)
//           .collection('tasks')
//           .get();
//
//       _tasks = snapshot.docs.map((doc) {
//         final data = doc.data();
//         return Task.fromFirestore(data, doc.id);
//       }).toList();
//
//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _error = 'Error loading tasks: $e';
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   /// Add a new task to Firestore
//   Future<void> addTask(Task task) async {
//     final user = _auth.currentUser;
//     if (user == null) return;
//
//     try {
//       final docRef = await _firestore
//           .collection('users')
//           .doc(user.uid)
//           .collection('tasks')
//           .add(task.toFirestore());
//
//       final newTask = Task(
//         id: docRef.id,
//         title: task.title,
//         description: task.description,
//         isCompleted: task.isCompleted,
//         createdAt: task.createdAt,
//         dueDate: task.dueDate,
//         priority: task.priority,
//         tags: task.tags,
//         subtasks: task.subtasks,
//       );
//
//       _tasks.add(newTask);
//       notifyListeners();
//     } catch (e) {
//       _error = 'Error adding task: $e';
//       notifyListeners();
//     }
//   }
//
//   /// Update an existing task
//   Future<void> updateTask(Task task) async {
//     final user = _auth.currentUser;
//     if (user == null) return;
//
//     try {
//       await _firestore
//           .collection('users')
//           .doc(user.uid)
//           .collection('tasks')
//           .doc(task.id)
//           .update(task.toFirestore());
//
//       final index = _tasks.indexWhere((t) => t.id == task.id);
//       if (index != -1) {
//         _tasks[index] = task;
//         notifyListeners();
//       }
//     } catch (e) {
//       _error = 'Error updating task: $e';
//       notifyListeners();
//     }
//   }
//
//   /// Toggle task completion status
//   Future<void> toggleTaskCompletion(String taskId) async {
//     final index = _tasks.indexWhere((t) => t.id == taskId);
//     if (index == -1) return;
//
//     final task = _tasks[index];
//     final updatedTask = Task(
//       id: task.id,
//       title: task.title,
//       description: task.description,
//       isCompleted: !task.isCompleted,
//       createdAt: task.createdAt,
//       dueDate: task.dueDate,
//       priority: task.priority,
//       tags: task.tags,
//       subtasks: task.subtasks,
//     );
//
//     await updateTask(updatedTask);
//
//     // Track completion in analytics
//     if (updatedTask.isCompleted) {
//       MixpanelService.instance.trackTaskCompleted(
//         taskId: taskId,
//         taskTitle: task.title,
//         priority: task.priority.toString().split('.').last,
//       );
//     }
//   }
//
//   /// Delete a task
//   Future<void> deleteTask(String taskId) async {
//     final user = _auth.currentUser;
//     if (user == null) return;
//
//     try {
//       await _firestore
//           .collection('users')
//           .doc(user.uid)
//           .collection('tasks')
//           .doc(taskId)
//           .delete();
//
//       _tasks.removeWhere((t) => t.id == taskId);
//       notifyListeners();
//     } catch (e) {
//       _error = 'Error deleting task: $e';
//       notifyListeners();
//     }
//   }
//
//   /// Set filter
//   void setFilter(TaskFilter filter) {
//     _currentFilter = filter;
//     notifyListeners();
//   }
//
//   /// Set sort order
//   void setSort(TaskSort sort) {
//     _currentSort = sort;
//     notifyListeners();
//   }
//
//   /// Get filtered and sorted tasks
//   List<Task> _getFilteredAndSortedTasks() {
//     List<Task> filtered = List.from(_tasks);
//
//     // Apply filter
//     switch (_currentFilter) {
//       case TaskFilter.completed:
//         filtered = filtered.where((t) => t.isCompleted).toList();
//         break;
//       case TaskFilter.pending:
//         filtered = filtered.where((t) => !t.isCompleted).toList();
//         break;
//       case TaskFilter.overdue:
//         filtered = filtered.where((t) => t.isOverdue).toList();
//         break;
//       case TaskFilter.today:
//         final today = DateTime.now();
//         filtered = filtered.where((t) {
//           if (t.dueDate == null) return false;
//           return t.dueDate!.year == today.year &&
//                  t.dueDate!.month == today.month &&
//                  t.dueDate!.day == today.day;
//         }).toList();
//         break;
//       case TaskFilter.all:
//         // No filter
//         break;
//     }
//
//     // Apply sort
//     switch (_currentSort) {
//       case TaskSort.dateCreated:
//         filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
//         break;
//       case TaskSort.dueDate:
//         filtered.sort((a, b) {
//           if (a.dueDate == null && b.dueDate == null) return 0;
//           if (a.dueDate == null) return 1;
//           if (b.dueDate == null) return -1;
//           return a.dueDate!.compareTo(b.dueDate!);
//         });
//         break;
//       case TaskSort.priority:
//         filtered.sort((a, b) {
//           final priorityOrder = {
//             TaskPriority.high: 0,
//             TaskPriority.medium: 1,
//             TaskPriority.low: 2,
//             TaskPriority.none: 3,
//           };
//           return (priorityOrder[a.priority] ?? 3)
//               .compareTo(priorityOrder[b.priority] ?? 3);
//         });
//         break;
//       case TaskSort.alphabetical:
//         filtered.sort((a, b) => a.title.compareTo(b.title));
//         break;
//     }
//
//     return filtered;
//   }
// }
