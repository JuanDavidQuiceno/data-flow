import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/habit.dart';

/// Conversiones entre la fila de Drift [db.Habit] y la entidad de dominio
/// [Habit]. El `orderIndex` se mantiene a nivel de fila y se asigna al insertar.
extension HabitRowMapper on db.Habit {
  Habit toEntity() => Habit(
        id: id,
        title: title,
        completed: completed,
      );
}

extension HabitEntityMapper on Habit {
  db.HabitsCompanion toCompanion({int? orderIndex}) => db.HabitsCompanion(
        id: Value(id),
        title: Value(title),
        completed: Value(completed),
        orderIndex:
            orderIndex == null ? const Value.absent() : Value(orderIndex),
      );
}
