import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/habits_dao.dart';
import 'daos/tasks_dao.dart';
import 'tables/habits_table.dart';
import 'tables/tasks_table.dart';

part 'app_database.g.dart';

/// Base de datos local de la aplicación (SQLite vía Drift).
///
/// Instancia única registrada en `main.dart`. Las nuevas tablas se agregan
/// a la lista de `@DriftDatabase` y se incrementa [schemaVersion].
@DriftDatabase(tables: [Tasks, Habits], daos: [TasksDao, HabitsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(habits);
          }
        },
      );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'dataflow');
}
