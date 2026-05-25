import '../entities/task.dart';

abstract class TasksRepository {
  Future<List<TaskItem>> getTodayTasks();
  Future<List<TaskItem>> getTomorrowTasks();
}
