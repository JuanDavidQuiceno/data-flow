import '../../domain/entities/habit.dart';
import '../../domain/repositories/habits_repository.dart';

class HabitsRepositoryImpl implements HabitsRepository {
  @override
  Future<HabitStreak> getStreak() async => const HabitStreak(12);

  @override
  Future<List<Habit>> getTodayHabits() async => const [
        Habit(id: '1', title: 'Beber 2L de agua', completed: true),
        Habit(id: '2', title: 'Ejercicio 30 min', completed: true),
        Habit(id: '3', title: 'Meditación 10 min', completed: false),
        Habit(id: '4', title: 'Dormir 7-8 horas', completed: true),
      ];
}
