import '../entities/weekly_stats.dart';

abstract class StatsRepository {
  Future<WeeklyStats> getWeeklyStats();
}
