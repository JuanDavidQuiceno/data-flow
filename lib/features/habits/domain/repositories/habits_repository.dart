import '../entities/habit.dart';

abstract class HabitsRepository {
  Future<HabitStreak> getStreak();
  Future<List<Habit>> getTodayHabits();
}
