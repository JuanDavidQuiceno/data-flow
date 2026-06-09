import '../entities/activity.dart';

abstract class HomeRepository {
  /// Resumen del día derivado de las tareas de hoy. Reemite ante cambios.
  Stream<DailySummary> watchDailySummary();

  /// Actividades de hoy (tareas de hoy mapeadas a [Activity]).
  Stream<List<Activity>> watchUpcomingActivities();
}
