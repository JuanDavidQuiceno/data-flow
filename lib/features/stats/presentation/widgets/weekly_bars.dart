import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/weekly_stats.dart';

class WeeklyBars extends StatelessWidget {
  final List<DayStat> days;
  const WeeklyBars({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final d in days)
            Expanded(child: _Bar(day: d)),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final DayStat day;
  const _Bar({required this.day});

  @override
  Widget build(BuildContext context) {
    final pct = day.total == 0 ? 0.0 : day.completed / day.total;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, box) {
              final maxH = box.maxHeight;
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: 18,
                    height: maxH,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  Container(
                    width: 18,
                    height: maxH * pct,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Text(
          day.label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
