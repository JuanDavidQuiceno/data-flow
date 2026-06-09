import 'package:flutter/material.dart';

enum ActivityCategory { academic, health, personal }

extension ActivityCategoryX on ActivityCategory {
  String get label => switch (this) {
        ActivityCategory.academic => 'Académica',
        ActivityCategory.health => 'Salud',
        ActivityCategory.personal => 'Personal',
      };

  Color get color => switch (this) {
        ActivityCategory.academic => const Color(0xFF3B82F6),
        ActivityCategory.health => const Color(0xFF22C55E),
        ActivityCategory.personal => const Color(0xFFF59E0B),
      };
}

class Activity {
  final String id;
  final String title;
  final String time;
  final ActivityCategory category;
  final bool completed;

  const Activity({
    required this.id,
    required this.title,
    required this.time,
    required this.category,
    this.completed = false,
  });
}

class DailySummary {
  final int total;
  final int completed;
  final int pending;
  final String greeting;
  final String dateLabel;

  const DailySummary({
    required this.total,
    required this.completed,
    required this.pending,
    required this.greeting,
    required this.dateLabel,
  });
}
