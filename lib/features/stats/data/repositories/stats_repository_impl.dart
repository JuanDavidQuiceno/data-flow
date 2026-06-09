import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/tasks_dao.dart';
import '../../domain/entities/weekly_stats.dart';
import '../../domain/repositories/stats_repository.dart';

/// Stats no tiene tabla propia: deriva de las tareas de la semana actual
/// (lunes a domingo), de modo que las gráficas reflejan datos reales.
class StatsRepositoryImpl implements StatsRepository {
  final TasksDao _tasksDao;

  StatsRepositoryImpl(this._tasksDao);

  static const _dayLabels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
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

  @override
  Stream<WeeklyStats> watchWeeklyStats() {
    return _tasksDao.watchAll().map(_buildStats);
  }

  WeeklyStats _buildStats(List<Task> rows) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // Lunes de la semana actual (weekday: lunes=1 ... domingo=7).
    final monday = today.subtract(Duration(days: today.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));

    bool sameDay(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;

    final days = <DayStat>[];
    var weekCompleted = 0;
    var weekTotal = 0;

    for (var i = 0; i < 7; i++) {
      final day = monday.add(Duration(days: i));
      final dayRows = rows.where((t) => sameDay(t.date, day)).toList();
      final completed = dayRows.where((t) => t.completed).length;
      weekCompleted += completed;
      weekTotal += dayRows.length;
      days.add(DayStat(
        label: _dayLabels[i],
        completed: completed.toDouble(),
        total: dayRows.length.toDouble(),
      ));
    }

    final pending = weekTotal - weekCompleted;
    final percentage = weekTotal == 0 ? 0.0 : weekCompleted / weekTotal;

    return WeeklyStats(
      periodLabel: 'Esta semana',
      rangeLabel: _rangeLabel(monday, sunday),
      percentage: percentage,
      completed: weekCompleted,
      pending: pending,
      // No existe un estado "omitida" en las tareas todavía.
      skipped: 0,
      days: days,
    );
  }

  String _rangeLabel(DateTime from, DateTime to) {
    if (from.month == to.month) {
      return '${from.day} - ${to.day} de ${_months[to.month - 1]}';
    }
    return '${from.day} de ${_months[from.month - 1]} - '
        '${to.day} de ${_months[to.month - 1]}';
  }
}
