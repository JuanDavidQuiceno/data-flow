import '../../../home/domain/entities/activity.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/tasks_repository.dart';

class TasksRepositoryImpl implements TasksRepository {
  @override
  Future<List<TaskItem>> getTodayTasks() async {
    final today = DateTime.now();
    return [
      TaskItem(
        id: '1',
        title: 'Estudiar Matemáticas',
        time: '10:00 AM',
        completed: false,
        category: ActivityCategory.academic,
        date: today,
      ),
      TaskItem(
        id: '2',
        title: 'Leer 20 páginas',
        time: '1:00 PM',
        completed: true,
        category: ActivityCategory.health,
        date: today,
      ),
      TaskItem(
        id: '3',
        title: 'Comprar mercado',
        time: '3:00 PM',
        completed: false,
        category: ActivityCategory.personal,
        date: today,
      ),
    ];
  }

  @override
  Future<List<TaskItem>> getTomorrowTasks() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return [
      TaskItem(
        id: '4',
        title: 'Entrega proyecto',
        time: '9:00 AM',
        completed: false,
        category: ActivityCategory.academic,
        date: tomorrow,
      ),
      TaskItem(
        id: '5',
        title: 'Llamar al médico',
        time: '11:00 AM',
        completed: false,
        category: ActivityCategory.personal,
        date: tomorrow,
      ),
    ];
  }
}
