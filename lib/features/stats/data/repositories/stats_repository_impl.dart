import '../../domain/entities/weekly_stats.dart';
import '../../domain/repositories/stats_repository.dart';

class StatsRepositoryImpl implements StatsRepository {
  @override
  Future<WeeklyStats> getWeeklyStats() async {
    return const WeeklyStats(
      periodLabel: 'Esta semana',
      rangeLabel: '8 - 14 de mayo',
      percentage: 0.78,
      completed: 21,
      pending: 6,
      skipped: 3,
      days: [
        DayStat(label: 'Lun', completed: 4, total: 5),
        DayStat(label: 'Mar', completed: 5, total: 5),
        DayStat(label: 'Mié', completed: 2, total: 4),
        DayStat(label: 'Jue', completed: 5, total: 5),
        DayStat(label: 'Vie', completed: 3, total: 5),
        DayStat(label: 'Sáb', completed: 1, total: 3),
        DayStat(label: 'Dom', completed: 1, total: 2),
      ],
    );
  }
}
