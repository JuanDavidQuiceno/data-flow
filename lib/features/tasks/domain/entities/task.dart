import '../../../home/domain/entities/activity.dart';

enum TaskFilter { todas, personal, academica, salud }

class TaskItem {
  final String id;
  final String title;
  final String time;
  final bool completed;
  final ActivityCategory category;
  final DateTime date;

  const TaskItem({
    required this.id,
    required this.title,
    required this.time,
    required this.completed,
    required this.category,
    required this.date,
  });
}
