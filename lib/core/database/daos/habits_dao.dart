import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/habits_table.dart';

part 'habits_dao.g.dart';

/// Acceso a datos de la tabla [Habits]: CRUD + observación reactiva.
@DriftAccessor(tables: [Habits])
class HabitsDao extends DatabaseAccessor<AppDatabase> with _$HabitsDaoMixin {
  HabitsDao(super.db);

  Stream<List<Habit>> watchAll() {
    return (select(habits)
          ..orderBy([(h) => OrderingTerm(expression: h.orderIndex)]))
        .watch();
  }

  Future<int> countAll() async {
    final query = selectOnly(habits)..addColumns([habits.id.count()]);
    final row = await query.getSingle();
    return row.read(habits.id.count()) ?? 0;
  }

  Future<void> insertHabit(HabitsCompanion habit) =>
      into(habits).insert(habit);

  Future<void> upsertHabit(HabitsCompanion habit) =>
      into(habits).insertOnConflictUpdate(habit);

  Future<int> deleteHabit(String id) =>
      (delete(habits)..where((h) => h.id.equals(id))).go();

  Future<void> insertAll(List<HabitsCompanion> rows) async {
    await batch((b) => b.insertAll(habits, rows));
  }
}
