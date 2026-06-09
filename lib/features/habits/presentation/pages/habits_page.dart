import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/app_database.dart' show AppDatabase;
import '../../../../core/theme/app_colors.dart';
import '../../data/repositories/habits_repository_impl.dart';
import '../../domain/entities/habit.dart';
import '../cubit/habits_cubit.dart';
import '../widgets/habit_form_sheet.dart';
import '../widgets/habit_tile.dart';

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    return BlocProvider(
      create: (_) => HabitsCubit(HabitsRepositoryImpl(db.habitsDao))..init(),
      child: const _HabitsView(),
    );
  }
}

class _HabitsView extends StatelessWidget {
  const _HabitsView();

  Future<void> _create(BuildContext context) async {
    final cubit = context.read<HabitsCubit>();
    final title = await showHabitFormSheet(context);
    if (title == null) return;
    await cubit.addHabit(
      Habit(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        completed: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        title: const Text('Hábitos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _create(context),
          ),
        ],
      ),
      body: BlocBuilder<HabitsCubit, HabitsState>(
        builder: (context, state) {
          if (state.status == HabitsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == HabitsStatus.error) {
            return Center(child: Text('Error: ${state.errorMessage ?? ''}'));
          }
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _StreakCard(days: state.streakDays),
              const SizedBox(height: 24),
              const Text(
                'Hábitos de hoy',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              if (state.habits.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Aún no tienes hábitos. Pulsa + para agregar uno.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                )
              else
                for (final h in state.habits) _DismissibleHabit(habit: h),
            ],
          );
        },
      ),
    );
  }
}

class _DismissibleHabit extends StatelessWidget {
  final Habit habit;
  const _DismissibleHabit({required this.habit});

  Future<void> _edit(BuildContext context) async {
    final cubit = context.read<HabitsCubit>();
    final title = await showHabitFormSheet(context, initial: habit);
    if (title == null) return;
    await cubit.updateHabit(
      Habit(id: habit.id, title: title, completed: habit.completed),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HabitsCubit>();
    return Dismissible(
      key: ValueKey(habit.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.danger,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => cubit.deleteHabit(habit.id),
      child: GestureDetector(
        onTap: () => _edit(context),
        child: HabitTile(
          habit: habit,
          onToggle: () => cubit.toggleCompleted(habit),
        ),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final int days;
  const _StreakCard({required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Racha diaria',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                color: AppColors.warning,
                size: 56,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$days',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    'días seguidos',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
