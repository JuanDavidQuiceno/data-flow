import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/tasks_dao.dart';
import 'tables/tasks_table.dart';

part 'app_database.g.dart';

/// Base de datos local de la aplicación (SQLite vía Drift).
///
/// Instancia única registrada en `main.dart`. Las nuevas tablas se agregan
/// a la lista de `@DriftDatabase` y se incrementa [schemaVersion].
@DriftDatabase(tables: [Tasks], daos: [TasksDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'dataflow');
}
