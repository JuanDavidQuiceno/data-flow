import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/activity.dart';
import '../../data/repositories/tasks_repository_impl.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/tasks_repository.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final TasksRepository _repository;
  StreamSubscription<List<TaskItem>>? _subscription;

  TasksCubit(this._repository) : super(const TasksState());

  /// Aplica el seed inicial (si procede) y comienza a escuchar los cambios.
  Future<void> init() async {
    final repo = _repository;
    if (repo is TasksRepositoryImpl) {
      await repo.seedIfEmpty();
    }
    _subscription?.cancel();
    _subscription = _repository.watchTasks().listen(
      (tasks) {
        emit(state.copyWith(status: TasksStatus.loaded, tasks: tasks));
      },
      onError: (Object e) {
        emit(state.copyWith(
          status: TasksStatus.error,
          errorMessage: e.toString(),
        ));
      },
    );
  }

  void changeFilter(TaskFilter filter) {
    emit(state.copyWith(filter: filter));
  }

  Future<void> addTask(TaskItem task) => _repository.addTask(task);

  Future<void> updateTask(TaskItem task) => _repository.updateTask(task);

  Future<void> deleteTask(String id) => _repository.deleteTask(id);

  Future<void> toggleCompleted(TaskItem task) =>
      _repository.toggleCompleted(task);

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
