import '../entities/task.dart';

abstract class TasksRepository {
  /// Emite la lista completa de tareas y reemite ante cualquier cambio.
  Stream<List<TaskItem>> watchTasks();

  Future<void> addTask(TaskItem task);
  Future<void> updateTask(TaskItem task);
  Future<void> deleteTask(String id);

  /// Alterna el estado de completado de una tarea.
  Future<void> toggleCompleted(TaskItem task);
}
