import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tasks_table.dart';

part 'tasks_dao.g.dart';

/// Acceso a datos de la tabla [Tasks]: CRUD + observación reactiva.
@DriftAccessor(tables: [Tasks])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(super.db);

  /// Emite la lista de tareas ordenadas por fecha cada vez que cambia la tabla.
  Stream<List<Task>> watchAll() {
    return (select(tasks)..orderBy([(t) => OrderingTerm(expression: t.date)]))
        .watch();
  }

  Future<List<Task>> getAll() {
    return (select(tasks)..orderBy([(t) => OrderingTerm(expression: t.date)]))
        .get();
  }

  Future<int> countAll() async {
    final query = selectOnly(tasks)..addColumns([tasks.id.count()]);
    final row = await query.getSingle();
    return row.read(tasks.id.count()) ?? 0;
  }

  Future<void> insertTask(TasksCompanion task) =>
      into(tasks).insert(task);

  Future<void> upsertTask(TasksCompanion task) =>
      into(tasks).insertOnConflictUpdate(task);

  Future<bool> updateTask(TasksCompanion task) =>
      update(tasks).replace(task);

  Future<int> deleteTask(String id) =>
      (delete(tasks)..where((t) => t.id.equals(id))).go();

  Future<void> insertAll(List<TasksCompanion> rows) async {
    await batch((b) => b.insertAll(tasks, rows));
  }
}
