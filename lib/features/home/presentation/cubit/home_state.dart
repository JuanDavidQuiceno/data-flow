part of 'home_cubit.dart';

enum HomeStatus { loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final DailySummary? summary;
  final List<Activity> activities;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.loading,
    this.summary,
    this.activities = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    DailySummary? summary,
    List<Activity>? activities,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      activities: activities ?? this.activities,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, summary, activities, errorMessage];
}
