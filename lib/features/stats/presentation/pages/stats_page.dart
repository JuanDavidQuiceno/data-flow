import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/repositories/stats_repository_impl.dart';
import '../../domain/entities/weekly_stats.dart';
import '../../domain/repositories/stats_repository.dart';
import '../widgets/donut_progress.dart';
import '../widgets/weekly_bars.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final StatsRepository _repository = StatsRepositoryImpl();
  late Future<WeeklyStats> _stats;

  @override
  void initState() {
    super.initState();
    _stats = _repository.getWeeklyStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas')),
      body: FutureBuilder<WeeklyStats>(
        future: _stats,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final s = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () {},
                        ),
                        Column(
                          children: [
                            Text(
                              s.periodLabel,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              s.rangeLabel,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Center(child: DonutProgress(value: s.percentage)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _StatColumn(
                      value: s.completed,
                      label: 'Completadas',
                    ),
                  ),
                  Expanded(
                    child: _StatColumn(
                      value: s.pending,
                      label: 'Pendientes',
                    ),
                  ),
                  Expanded(
                    child: _StatColumn(
                      value: s.skipped,
                      label: 'Omitidas',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              WeeklyBars(days: s.days),
            ],
          );
        },
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final int value;
  final String label;
  const _StatColumn({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
