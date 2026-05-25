import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/activity.dart';
import '../../domain/repositories/home_repository.dart';
import '../widgets/activity_tile.dart';
import '../widgets/summary_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeRepository _repository = HomeRepositoryImpl();
  late Future<DailySummary> _summary;
  late Future<List<Activity>> _activities;

  @override
  void initState() {
    super.initState();
    _summary = _repository.getDailySummary();
    _activities = _repository.getUpcomingActivities();
  }

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
      body: FutureBuilder<DailySummary>(
        future: _summary,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final s = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(s.greeting, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(s.dateLabel,
                  style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              const Text('Resumen de hoy',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
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
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              FutureBuilder<List<Activity>>(
                future: _activities,
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    children: [
                      for (final a in snap.data!) ...[
                        ActivityTile(activity: a),
                        const SizedBox(height: 10),
                      ],
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
