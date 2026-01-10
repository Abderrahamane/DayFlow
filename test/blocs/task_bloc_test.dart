import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dayflow/blocs/task/task_bloc.dart';
import 'package:dayflow/data/repositories/task_repository.dart';
import 'package:dayflow/models/task_model.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

// Fake Task class for mocktail
class FakeTask extends Fake implements Task {}

void main() {
  late MockTaskRepository mockTaskRepository;

  setUpAll(() {
    registerFallbackValue(FakeTask());
  });

  setUp(() {
    mockTaskRepository = MockTaskRepository();
  });

  group('TaskBloc', () {
    final testTask = Task(
      id: 'task-1',
      title: 'Test Task',
      description: 'Test Description',
      isCompleted: false,
      createdAt: DateTime.now(),
      priority: TaskPriority.medium,
    );

    final testTasks = [
      testTask,
      Task(
        id: 'task-2',
        title: 'Another Task',
        isCompleted: true,
        createdAt: DateTime.now(),
      ),
    ];

    blocTest<TaskBloc, TaskState>(
      'emits [loading, ready] when LoadTasks is added and succeeds',
      build: () {
        when(() => mockTaskRepository.fetchTasks())
            .thenAnswer((_) async => testTasks);
        return TaskBloc(mockTaskRepository);
      },
      act: (bloc) => bloc.add(LoadTasks()),
      expect: () => [
        TaskState.initial().copyWith(status: TaskStatus.loading),
        TaskState.initial().copyWith(
          status: TaskStatus.ready,
          tasks: testTasks,
        ),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [loading, failure] when LoadTasks fails',
      build: () {
        when(() => mockTaskRepository.fetchTasks())
            .thenThrow(Exception('Failed to load tasks'));
        return TaskBloc(mockTaskRepository);
      },
      act: (bloc) => bloc.add(LoadTasks()),
      expect: () => [
        TaskState.initial().copyWith(status: TaskStatus.loading),
        isA<TaskState>()
            .having((s) => s.status, 'status', TaskStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', isNotEmpty),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits state with new task when AddOrUpdateTask is added',
      build: () {
        when(() => mockTaskRepository.upsertTask(any()))
            .thenAnswer((_) async {});
        return TaskBloc(mockTaskRepository);
      },
      seed: () => TaskState.initial().copyWith(
        status: TaskStatus.ready,
        tasks: [],
      ),
      act: (bloc) => bloc.add(AddOrUpdateTask(testTask)),
      expect: () => [
        isA<TaskState>()
            .having((s) => s.tasks.length, 'tasks length', 1)
            .having((s) => s.tasks.first.title, 'task title', testTask.title),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits state without task when DeleteTaskEvent is added',
      build: () {
        when(() => mockTaskRepository.deleteTask(any()))
            .thenAnswer((_) async {});
        return TaskBloc(mockTaskRepository);
      },
      seed: () => TaskState.initial().copyWith(
        status: TaskStatus.ready,
        tasks: [testTask],
      ),
      act: (bloc) => bloc.add(DeleteTaskEvent(testTask.id)),
      expect: () => [
        isA<TaskState>().having((s) => s.tasks, 'tasks', isEmpty),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits state with toggled completion when ToggleTaskCompletionEvent is added',
      build: () {
        when(() => mockTaskRepository.toggleTaskCompletion(any()))
            .thenAnswer((_) async {});
        return TaskBloc(mockTaskRepository);
      },
      seed: () => TaskState.initial().copyWith(
        status: TaskStatus.ready,
        tasks: [testTask],
      ),
      act: (bloc) => bloc.add(ToggleTaskCompletionEvent(testTask.id)),
      expect: () => [
        isA<TaskState>()
            .having((s) => s.tasks.first.isCompleted, 'isCompleted', true),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits state with new filter when ChangeTaskFilter is added',
      build: () => TaskBloc(mockTaskRepository),
      seed: () => TaskState.initial().copyWith(
        status: TaskStatus.ready,
        filter: TaskFilter.all,
      ),
      act: (bloc) => bloc.add(const ChangeTaskFilter(TaskFilter.completed)),
      expect: () => [
        isA<TaskState>().having((s) => s.filter, 'filter', TaskFilter.completed),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits state with new sort when ChangeTaskSort is added',
      build: () => TaskBloc(mockTaskRepository),
      seed: () => TaskState.initial().copyWith(
        status: TaskStatus.ready,
        sort: TaskSort.dateCreated,
      ),
      act: (bloc) => bloc.add(const ChangeTaskSort(TaskSort.priority)),
      expect: () => [
        isA<TaskState>().having((s) => s.sort, 'sort', TaskSort.priority),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits state with search query when SearchTasks is added',
      build: () => TaskBloc(mockTaskRepository),
      seed: () => TaskState.initial().copyWith(
        status: TaskStatus.ready,
        searchQuery: '',
      ),
      act: (bloc) => bloc.add(const SearchTasks('test query')),
      expect: () => [
        isA<TaskState>()
            .having((s) => s.searchQuery, 'searchQuery', 'test query'),
      ],
    );
  });

  group('TaskState', () {
    test('initial state has correct default values', () {
      final state = TaskState.initial();

      expect(state.tasks, isEmpty);
      expect(state.filter, TaskFilter.all);
      expect(state.sort, TaskSort.dateCreated);
      expect(state.status, TaskStatus.initial);
      expect(state.searchQuery, '');
    });

    test('visibleTasks filters completed tasks correctly', () {
      final tasks = [
        Task(
          id: '1',
          title: 'Task 1',
          isCompleted: true,
          createdAt: DateTime.now(),
        ),
        Task(
          id: '2',
          title: 'Task 2',
          isCompleted: false,
          createdAt: DateTime.now(),
        ),
      ];

      final state = TaskState.initial().copyWith(
        tasks: tasks,
        filter: TaskFilter.completed,
        status: TaskStatus.ready,
      );

      expect(state.visibleTasks.length, 1);
      expect(state.visibleTasks.first.id, '1');
    });

    test('completedCount returns correct count', () {
      final tasks = [
        Task(id: '1', title: 'Task 1', isCompleted: true, createdAt: DateTime.now()),
        Task(id: '2', title: 'Task 2', isCompleted: true, createdAt: DateTime.now()),
        Task(id: '3', title: 'Task 3', isCompleted: false, createdAt: DateTime.now()),
      ];

      final state = TaskState.initial().copyWith(tasks: tasks);

      expect(state.completedCount, 2);
      expect(state.pendingCount, 1);
    });
  });
}

