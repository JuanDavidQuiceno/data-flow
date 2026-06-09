part of 'tasks_cubit.dart';

enum TasksStatus { loading, loaded, error }

class TasksState extends Equatable {
  final TasksStatus status;
  final List<TaskItem> tasks;
  final TaskFilter filter;
  final String? errorMessage;

  const TasksState({
    this.status = TasksStatus.loading,
    this.tasks = const [],
    this.filter = TaskFilter.todas,
    this.errorMessage,
  });

  /// Categoría asociada a cada filtro (null = sin filtrar).
  static ActivityCategory? _categoryFor(TaskFilter filter) => switch (filter) {
        TaskFilter.todas => null,
        TaskFilter.personal => ActivityCategory.personal,
        TaskFilter.academica => ActivityCategory.academic,
        TaskFilter.salud => ActivityCategory.health,
      };

  List<TaskItem> get _visible {
    final category = _categoryFor(filter);
    if (category == null) return tasks;
    return tasks.where((t) => t.category == category).toList();
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<TaskItem> get todayTasks {
    final now = DateTime.now();
    return _visible.where((t) => _isSameDay(t.date, now)).toList();
  }

  List<TaskItem> get tomorrowTasks {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return _visible.where((t) => _isSameDay(t.date, tomorrow)).toList();
  }

  TasksState copyWith({
    TasksStatus? status,
    List<TaskItem>? tasks,
    TaskFilter? filter,
    String? errorMessage,
  }) {
    return TasksState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      filter: filter ?? this.filter,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, tasks, filter, errorMessage];
}
