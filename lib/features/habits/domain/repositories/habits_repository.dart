import '../entities/habit.dart';

abstract class HabitsRepository {
  /// Emite la lista de hábitos y reemite ante cualquier cambio.
  Stream<List<Habit>> watchHabits();

  /// Racha calculada a partir de los hábitos actuales.
  Future<HabitStreak> getStreak();

  Future<void> addHabit(Habit habit);
  Future<void> updateHabit(Habit habit);
  Future<void> deleteHabit(String id);

  /// Alterna el estado de completado de un hábito.
  Future<void> toggleCompleted(Habit habit);
}
