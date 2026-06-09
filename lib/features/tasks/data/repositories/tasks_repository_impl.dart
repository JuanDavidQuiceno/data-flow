import '../../../../core/database/daos/tasks_dao.dart';
import '../../../home/domain/entities/activity.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../models/task_mapper.dart';

class TasksRepositoryImpl implements TasksRepository {
  final TasksDao _dao;

  TasksRepositoryImpl(this._dao);

  @override
  Stream<List<TaskItem>> watchTasks() {
    return _dao.watchAll().map(
          (rows) => rows.map((r) => r.toEntity()).toList(),
        );
  }

  @override
  Future<void> addTask(TaskItem task) => _dao.insertTask(task.toCompanion());

  @override
  Future<void> updateTask(TaskItem task) => _dao.upsertTask(task.toCompanion());

  @override
  Future<void> deleteTask(String id) => _dao.deleteTask(id);

  @override
  Future<void> toggleCompleted(TaskItem task) {
    return _dao.upsertTask(
      TaskItem(
        id: task.id,
        title: task.title,
        time: task.time,
        completed: !task.completed,
        category: task.category,
        date: task.date,
      ).toCompanion(),
    );
  }

  /// Inserta los datos de ejemplo la primera vez que se abre la app
  /// (cuando la tabla está vacía).
  Future<void> seedIfEmpty() async {
    final count = await _dao.countAll();
    if (count > 0) return;

    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final seed = [
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

    await _dao.insertAll(seed.map((t) => t.toCompanion()).toList());
  }
}
