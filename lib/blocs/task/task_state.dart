part of 'task_bloc.dart';

enum TaskStatus { initial, loading, ready, failure }

class TaskState extends Equatable {
  final List<Task> tasks;
  final TaskFilter filter;
  final TaskSort sort;
  final TaskStatus status;
  final String? errorMessage;
  final String searchQuery;

  const TaskState({
    required this.tasks,
    required this.filter,
    required this.sort,
    required this.status,
    this.errorMessage,
    this.searchQuery = '',
  });

  factory TaskState.initial() => const TaskState(
        tasks: [],
        filter: TaskFilter.all,
        sort: TaskSort.dateCreated,
        status: TaskStatus.initial,
        searchQuery: '',
      );

  List<Task> get visibleTasks => _applyFilterAndSort(tasks);

  int get completedCount => tasks.where((t) => t.isCompleted).length;
  int get pendingCount => tasks.where((t) => !t.isCompleted).length;
  int get overdueCount => tasks.where((t) => t.isOverdue).length;

  TaskState copyWith({
    List<Task>? tasks,
    TaskFilter? filter,
    TaskSort? sort,
    TaskStatus? status,
    String? errorMessage,
    String? searchQuery,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [tasks, filter, sort, status, errorMessage, searchQuery];

  List<Task> _applyFilterAndSort(List<Task> tasks) {
    var filtered = List<Task>.from(tasks);

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((t) {
        return t.title.toLowerCase().contains(query) ||
            (t.description?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    switch (filter) {
      case TaskFilter.completed:
        filtered = filtered.where((t) => t.isCompleted).toList();
        break;
      case TaskFilter.pending:
        filtered = filtered.where((t) => !t.isCompleted).toList();
        break;
      case TaskFilter.overdue:
        filtered = filtered.where((t) => t.isOverdue).toList();
        break;
      case TaskFilter.today:
        final today = DateTime.now();
        filtered = filtered.where((t) {
          if (t.dueDate == null) return false;
          return t.dueDate!.year == today.year &&
              t.dueDate!.month == today.month &&
              t.dueDate!.day == today.day;
        }).toList();
        break;
      case TaskFilter.all:
        break;
    }

    switch (sort) {
      case TaskSort.dateCreated:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case TaskSort.dueDate:
        filtered.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      case TaskSort.priority:
        filtered.sort((a, b) => a.priority.index.compareTo(b.priority.index));
        break;
      case TaskSort.alphabetical:
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
    }

    return filtered;
  }
}
