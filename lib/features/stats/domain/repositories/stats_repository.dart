import '../entities/weekly_stats.dart';

abstract class StatsRepository {
  /// Estadísticas de la semana actual derivadas de las tareas. Reemite
  /// ante cualquier cambio en las tareas.
  Stream<WeeklyStats> watchWeeklyStats();
}
