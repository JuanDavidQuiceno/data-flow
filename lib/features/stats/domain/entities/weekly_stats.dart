class DayStat {
  final String label;
  final double completed;
  final double total;

  const DayStat({
    required this.label,
    required this.completed,
    required this.total,
  });
}

class WeeklyStats {
  final String periodLabel;
  final String rangeLabel;
  final double percentage;
  final int completed;
  final int pending;
  final int skipped;
  final List<DayStat> days;

  const WeeklyStats({
    required this.periodLabel,
    required this.rangeLabel,
    required this.percentage,
    required this.completed,
    required this.pending,
    required this.skipped,
    required this.days,
  });
}
