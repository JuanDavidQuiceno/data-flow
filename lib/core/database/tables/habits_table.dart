import 'package:drift/drift.dart';

/// Tabla de hábitos. [orderIndex] mantiene el orden de la lista.
class Habits extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
