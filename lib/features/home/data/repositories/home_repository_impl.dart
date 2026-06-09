import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/tasks_dao.dart';
import '../../domain/entities/activity.dart';
import '../../domain/repositories/home_repository.dart';

/// Home no tiene tabla propia: deriva su contenido de las tareas de hoy,
/// de modo que el resumen y las actividades reflejan lo que el usuario
/// gestiona en el módulo de Tareas (una sola fuente de verdad).
class HomeRepositoryImpl implements HomeRepository {
  final TasksDao _tasksDao;

  HomeRepositoryImpl(this._tasksDao);

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  List<Task> _todayRows(List<Task> rows) =>
      rows.where((t) => _isToday(t.date)).toList();

  @override
  Stream<DailySummary> watchDailySummary() {
    return _tasksDao.watchAll().map((rows) {
      final today = _todayRows(rows);
      final completed = today.where((t) => t.completed).length;
      return DailySummary(
        total: today.length,
        completed: completed,
        pending: today.length - completed,
        greeting: '¡Hola!',
        dateLabel: _formatDate(DateTime.now()),
      );
    });
  }

  @override
  Stream<List<Activity>> watchUpcomingActivities() {
    return _tasksDao.watchAll().map((rows) {
      final today = _todayRows(rows)..sort((a, b) => a.time.compareTo(b.time));
      return today
          .map((t) => Activity(
                id: t.id,
                title: t.title,
                time: t.time,
                category: ActivityCategory.values[t.category],
                completed: t.completed,
              ))
          .toList();
    });
  }

  static const _weekdays = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  static const _months = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];

  String _formatDate(DateTime d) {
    final weekday = _weekdays[d.weekday - 1];
    final month = _months[d.month - 1];
    return '$weekday, ${d.day} de $month';
  }
}
