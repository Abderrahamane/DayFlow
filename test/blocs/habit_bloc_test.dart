import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dayflow/blocs/habit/habit_bloc.dart';
import 'package:dayflow/data/repositories/habit_repository.dart';
import 'package:dayflow/models/habit_model.dart';

class MockHabitRepository extends Mock implements HabitRepository {}

// Fake Habit class for mocktail
class FakeHabit extends Fake implements Habit {}

void main() {
  late MockHabitRepository mockHabitRepository;

  setUpAll(() {
    registerFallbackValue(FakeHabit());
  });

  setUp(() {
    mockHabitRepository = MockHabitRepository();
  });

  group('HabitBloc', () {
    final testHabit = Habit(
      id: 'habit-1',
      name: 'Exercise',
      description: 'Daily workout',
      icon: '🏃',
      frequency: HabitFrequency.daily,
      goalCount: 1,
      createdAt: DateTime.now(),
      color: Colors.blue,
    );

    final testHabits = [
      testHabit,
      Habit(
        id: 'habit-2',
        name: 'Reading',
        icon: '📚',
        frequency: HabitFrequency.daily,
        goalCount: 1,
        createdAt: DateTime.now(),
        color: Colors.green,
      ),
    ];

    blocTest<HabitBloc, HabitState>(
      'emits [loading, ready] when LoadHabits is added and succeeds',
      build: () {
        when(() => mockHabitRepository.fetchHabits())
            .thenAnswer((_) async => testHabits);
        return HabitBloc(mockHabitRepository);
      },
      act: (bloc) => bloc.add(LoadHabits()),
      expect: () => [
        const HabitState(status: HabitStatus.loading),
        HabitState(status: HabitStatus.ready, habits: testHabits),
      ],
    );

    blocTest<HabitBloc, HabitState>(
      'emits [loading, failure] when LoadHabits fails',
      build: () {
        when(() => mockHabitRepository.fetchHabits())
            .thenThrow(Exception('Failed to load habits'));
        return HabitBloc(mockHabitRepository);
      },
      act: (bloc) => bloc.add(LoadHabits()),
      expect: () => [
        const HabitState(status: HabitStatus.loading),
        isA<HabitState>()
            .having((s) => s.status, 'status', HabitStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', isNotEmpty),
      ],
    );

    blocTest<HabitBloc, HabitState>(
      'emits state with new habit when AddOrUpdateHabit is added',
      build: () {
        when(() => mockHabitRepository.upsertHabit(any()))
            .thenAnswer((_) async {});
        return HabitBloc(mockHabitRepository);
      },
      seed: () => const HabitState(status: HabitStatus.ready, habits: []),
      act: (bloc) => bloc.add(AddOrUpdateHabit(testHabit)),
      expect: () => [
        isA<HabitState>()
            .having((s) => s.habits.length, 'habits length', 1)
            .having((s) => s.habits.first.name, 'habit name', testHabit.name),
      ],
    );

    blocTest<HabitBloc, HabitState>(
      'emits state without habit when DeleteHabitEvent is added',
      build: () {
        when(() => mockHabitRepository.deleteHabit(any()))
            .thenAnswer((_) async {});
        return HabitBloc(mockHabitRepository);
      },
      seed: () => HabitState(status: HabitStatus.ready, habits: [testHabit]),
      act: (bloc) => bloc.add(DeleteHabitEvent(testHabit.id)),
      expect: () => [
        isA<HabitState>().having((s) => s.habits, 'habits', isEmpty),
      ],
    );

    blocTest<HabitBloc, HabitState>(
      'emits state with toggled completion when ToggleHabitCompletionEvent is added',
      build: () {
        when(() => mockHabitRepository.toggleCompletion(any(), any()))
            .thenAnswer((_) async {});
        return HabitBloc(mockHabitRepository);
      },
      seed: () => HabitState(status: HabitStatus.ready, habits: [testHabit]),
      act: (bloc) => bloc.add(ToggleHabitCompletionEvent(
        habitId: testHabit.id,
        dateKey: Habit.getDateKey(DateTime.now()),
      )),
      expect: () => [
        isA<HabitState>().having(
          (s) => s.habits.first.completionHistory.isNotEmpty,
          'has completion history',
          true,
        ),
      ],
    );

    blocTest<HabitBloc, HabitState>(
      'emits state with search query when SearchHabits is added',
      build: () => HabitBloc(mockHabitRepository),
      seed: () => const HabitState(status: HabitStatus.ready, searchQuery: ''),
      act: (bloc) => bloc.add(const SearchHabits('exercise')),
      expect: () => [
        isA<HabitState>()
            .having((s) => s.searchQuery, 'searchQuery', 'exercise'),
      ],
    );
  });

  group('HabitState', () {
    test('initial state has correct default values', () {
      const state = HabitState();

      expect(state.habits, isEmpty);
      expect(state.status, HabitStatus.initial);
      expect(state.searchQuery, '');
    });

    test('completedToday returns correct count', () {
      final today = Habit.getDateKey(DateTime.now());
      final habits = [
        Habit(
          id: '1',
          name: 'Habit 1',
          icon: '🏃',
          frequency: HabitFrequency.daily,
          goalCount: 1,
          createdAt: DateTime.now(),
          color: Colors.blue,
          completionHistory: {today: true},
        ),
        Habit(
          id: '2',
          name: 'Habit 2',
          icon: '📚',
          frequency: HabitFrequency.daily,
          goalCount: 1,
          createdAt: DateTime.now(),
          color: Colors.green,
          completionHistory: {},
        ),
      ];

      final state = HabitState(habits: habits);

      expect(state.completedToday, 1);
    });

    test('visibleHabits filters by search query', () {
      final habits = [
        Habit(
          id: '1',
          name: 'Exercise',
          icon: '🏃',
          frequency: HabitFrequency.daily,
          goalCount: 1,
          createdAt: DateTime.now(),
          color: Colors.blue,
        ),
        Habit(
          id: '2',
          name: 'Reading',
          icon: '📚',
          frequency: HabitFrequency.daily,
          goalCount: 1,
          createdAt: DateTime.now(),
          color: Colors.green,
        ),
      ];

      final state = HabitState(
        habits: habits,
        searchQuery: 'exercise',
      );

      expect(state.visibleHabits.length, 1);
      expect(state.visibleHabits.first.name, 'Exercise');
    });
  });
}

