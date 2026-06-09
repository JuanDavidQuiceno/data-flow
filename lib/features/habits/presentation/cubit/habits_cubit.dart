import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/habits_repository_impl.dart';
import '../../domain/entities/habit.dart';
import '../../domain/repositories/habits_repository.dart';

part 'habits_state.dart';

class HabitsCubit extends Cubit<HabitsState> {
  final HabitsRepository _repository;
  StreamSubscription<List<Habit>>? _subscription;

  HabitsCubit(this._repository) : super(const HabitsState());

  /// Aplica el seed inicial (si procede) y comienza a escuchar los cambios.
  Future<void> init() async {
    final repo = _repository;
    if (repo is HabitsRepositoryImpl) {
      await repo.seedIfEmpty();
    }
    _subscription?.cancel();
    _subscription = _repository.watchHabits().listen(
      (habits) {
        emit(state.copyWith(status: HabitsStatus.loaded, habits: habits));
      },
      onError: (Object e) {
        emit(state.copyWith(
          status: HabitsStatus.error,
          errorMessage: e.toString(),
        ));
      },
    );
  }

  Future<void> addHabit(Habit habit) => _repository.addHabit(habit);

  Future<void> updateHabit(Habit habit) => _repository.updateHabit(habit);

  Future<void> deleteHabit(String id) => _repository.deleteHabit(id);

  Future<void> toggleCompleted(Habit habit) =>
      _repository.toggleCompleted(habit);

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
