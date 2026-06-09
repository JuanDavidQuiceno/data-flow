part of 'stats_cubit.dart';

enum StatsStatus { loading, loaded, error }

class StatsState extends Equatable {
  final StatsStatus status;
  final WeeklyStats? stats;
  final String? errorMessage;

  const StatsState({
    this.status = StatsStatus.loading,
    this.stats,
    this.errorMessage,
  });

  StatsState copyWith({
    StatsStatus? status,
    WeeklyStats? stats,
    String? errorMessage,
  }) {
    return StatsState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, stats, errorMessage];
}
