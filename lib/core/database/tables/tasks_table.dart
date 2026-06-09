import 'package:drift/drift.dart';

/// Tabla de tareas. La categoría se guarda como índice del enum
/// [ActivityCategory] y la fecha como [DateTime].
class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get time => text()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  IntColumn get category => integer()();
  DateTimeColumn get date => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
