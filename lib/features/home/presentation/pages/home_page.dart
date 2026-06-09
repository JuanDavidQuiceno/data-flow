import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/app_database.dart' show AppDatabase;
import '../../../../core/theme/app_colors.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../cubit/home_cubit.dart';
import '../widgets/activity_tile.dart';
import '../widgets/summary_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    return BlocProvider(
      create: (_) => HomeCubit(HomeRepositoryImpl(db.tasksDao))..init(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: const Text('DayFlow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading || state.summary == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == HomeStatus.error) {
            return Center(child: Text('Error: ${state.errorMessage ?? ''}'));
          }
          final s = state.summary!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(s.greeting, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(s.dateLabel,
                  style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              const Text('Resumen de hoy',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      icon: Icons.calendar_today_outlined,
                      value: s.total,
                      label: 'Actividades\ntotales',
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SummaryCard(
                      icon: Icons.check_circle_outline,
                      value: s.completed,
                      label: 'Completadas',
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SummaryCard(
                      icon: Icons.assignment_outlined,
                      value: s.pending,
                      label: 'Pendientes',
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const Text('Próximas actividades',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              if (state.activities.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'No tienes actividades para hoy.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                )
              else
                for (final a in state.activities) ...[
                  ActivityTile(activity: a),
                  const SizedBox(height: 10),
                ],
            ],
          );
        },
      ),
    );
  }
}
