import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/activity.dart';
import '../../domain/repositories/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;
  StreamSubscription<DailySummary>? _summarySub;
  StreamSubscription<List<Activity>>? _activitiesSub;

  HomeCubit(this._repository) : super(const HomeState());

  void init() {
    _summarySub?.cancel();
    _activitiesSub?.cancel();

    _summarySub = _repository.watchDailySummary().listen(
      (summary) {
        emit(state.copyWith(status: HomeStatus.loaded, summary: summary));
      },
      onError: (Object e) => emit(
        state.copyWith(status: HomeStatus.error, errorMessage: e.toString()),
      ),
    );

    _activitiesSub = _repository.watchUpcomingActivities().listen(
      (activities) {
        emit(state.copyWith(
          status: HomeStatus.loaded,
          activities: activities,
        ));
      },
      onError: (Object e) => emit(
        state.copyWith(status: HomeStatus.error, errorMessage: e.toString()),
      ),
    );
  }

  @override
  Future<void> close() {
    _summarySub?.cancel();
    _activitiesSub?.cancel();
    return super.close();
  }
}
