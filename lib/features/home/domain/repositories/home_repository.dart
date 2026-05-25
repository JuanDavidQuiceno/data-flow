import '../entities/activity.dart';

abstract class HomeRepository {
  Future<DailySummary> getDailySummary();
  Future<List<Activity>> getUpcomingActivities();
}
