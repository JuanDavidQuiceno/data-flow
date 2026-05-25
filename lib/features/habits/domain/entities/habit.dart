class Habit {
  final String id;
  final String title;
  final bool completed;

  const Habit({
    required this.id,
    required this.title,
    required this.completed,
  });
}

class HabitStreak {
  final int days;
  const HabitStreak(this.days);
}
