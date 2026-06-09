import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../home/domain/entities/activity.dart';
import '../../domain/entities/task.dart';

/// Conversiones entre la fila de Drift [Task] y la entidad de dominio
/// [TaskItem]. La categoría se persiste como índice del enum.
extension TaskRowMapper on Task {
  TaskItem toEntity() => TaskItem(
        id: id,
        title: title,
        time: time,
        completed: completed,
        category: ActivityCategory.values[category],
        date: date,
      );
}

extension TaskItemMapper on TaskItem {
  TasksCompanion toCompanion() => TasksCompanion(
        id: Value(id),
        title: Value(title),
        time: Value(time),
        completed: Value(completed),
        category: Value(category.index),
        date: Value(date),
      );
}
