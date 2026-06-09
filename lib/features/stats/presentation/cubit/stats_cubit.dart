import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/weekly_stats.dart';
import '../../domain/repositories/stats_repository.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  final StatsRepository _repository;
  StreamSubscription<WeeklyStats>? _subscription;

  StatsCubit(this._repository) : super(const StatsState());

  void init() {
    _subscription?.cancel();
    _subscription = _repository.watchWeeklyStats().listen(
      (stats) {
        emit(state.copyWith(status: StatsStatus.loaded, stats: stats));
      },
      onError: (Object e) => emit(
        state.copyWith(status: StatsStatus.error, errorMessage: e.toString()),
      ),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
