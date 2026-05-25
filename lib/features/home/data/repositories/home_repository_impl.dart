import '../../domain/entities/activity.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<DailySummary> getDailySummary() async {
    return const DailySummary(
      total: 5,
      completed: 3,
      pending: 2,
      greeting: '¡Hola, Juan!',
      dateLabel: 'Miércoles, 14 de mayo',
    );
  }

  @override
  Future<List<Activity>> getUpcomingActivities() async {
    return const [
      Activity(
        id: '1',
        title: 'Estudiar Matemáticas',
        time: '10:00',
        category: ActivityCategory.academic,
      ),
      Activity(
        id: '2',
        title: 'Entrenamiento',
        time: '11:30',
        category: ActivityCategory.health,
      ),
      Activity(
        id: '3',
        title: 'Comprar mercado',
        time: '15:00',
        category: ActivityCategory.personal,
      ),
    ];
  }
}
