part of 'habits_cubit.dart';

enum HabitsStatus { loading, loaded, error }

class HabitsState extends Equatable {
  final HabitsStatus status;
  final List<Habit> habits;
  final String? errorMessage;

  const HabitsState({
    this.status = HabitsStatus.loading,
    this.habits = const [],
    this.errorMessage,
  });

  /// Racha derivada: nº de hábitos completados hoy.
  /// TODO: reemplazar por racha real cuando exista historial diario.
  int get streakDays => habits.where((h) => h.completed).length;

  HabitsState copyWith({
    HabitsStatus? status,
    List<Habit>? habits,
    String? errorMessage,
  }) {
    return HabitsState(
      status: status ?? this.status,
      habits: habits ?? this.habits,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, habits, errorMessage];
}
