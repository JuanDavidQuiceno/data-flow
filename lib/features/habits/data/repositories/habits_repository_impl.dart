import '../../../../core/database/daos/habits_dao.dart';
import '../../domain/entities/habit.dart';
import '../../domain/repositories/habits_repository.dart';
import '../models/habit_mapper.dart';

class HabitsRepositoryImpl implements HabitsRepository {
  final HabitsDao _dao;

  HabitsRepositoryImpl(this._dao);

  @override
  Stream<List<Habit>> watchHabits() {
    return _dao.watchAll().map(
          (rows) => rows.map((r) => r.toEntity()).toList(),
        );
  }

  @override
  Future<HabitStreak> getStreak() async {
    // Sin tabla de historial todavía: la racha refleja cuántos hábitos
    // de hoy están completos. TODO: historial diario para racha real.
    final habits = await _dao.watchAll().first;
    final completed = habits.where((h) => h.completed).length;
    return HabitStreak(completed);
  }

  @override
  Future<void> addHabit(Habit habit) async {
    final order = await _dao.countAll();
    await _dao.insertHabit(habit.toCompanion(orderIndex: order));
  }

  @override
  Future<void> updateHabit(Habit habit) => _dao.upsertHabit(habit.toCompanion());

  @override
  Future<void> deleteHabit(String id) => _dao.deleteHabit(id);

  @override
  Future<void> toggleCompleted(Habit habit) {
    return _dao.upsertHabit(
      Habit(
        id: habit.id,
        title: habit.title,
        completed: !habit.completed,
      ).toCompanion(),
    );
  }

  /// Inserta los hábitos de ejemplo la primera vez (tabla vacía).
  Future<void> seedIfEmpty() async {
    final count = await _dao.countAll();
    if (count > 0) return;

    const seed = [
      Habit(id: '1', title: 'Beber 2L de agua', completed: true),
      Habit(id: '2', title: 'Ejercicio 30 min', completed: true),
      Habit(id: '3', title: 'Meditación 10 min', completed: false),
      Habit(id: '4', title: 'Dormir 7-8 horas', completed: true),
    ];

    final rows = [
      for (var i = 0; i < seed.length; i++)
        seed[i].toCompanion(orderIndex: i),
    ];
    await _dao.insertAll(rows);
  }
}
