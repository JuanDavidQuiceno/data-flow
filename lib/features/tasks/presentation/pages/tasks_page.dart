import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/app_database.dart';
import '../../data/repositories/tasks_repository_impl.dart';
import '../../domain/entities/task.dart';
import '../cubit/tasks_cubit.dart';
import '../widgets/task_form_sheet.dart';
import '../widgets/task_tile.dart';
import '../../../../core/theme/app_colors.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    return BlocProvider(
      create: (_) => TasksCubit(TasksRepositoryImpl(db.tasksDao))..init(),
      child: const _TasksView(),
    );
  }
}

class _TasksView extends StatelessWidget {
  const _TasksView();

  Future<void> _openForm(BuildContext context, {TaskItem? initial}) async {
    final cubit = context.read<TasksCubit>();
    final result = await showTaskFormSheet(context, initial: initial);
    if (result == null) return;

    if (initial == null) {
      await cubit.addTask(
        TaskItem(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: result.title,
          time: result.time,
          completed: false,
          category: result.category,
          date: result.date,
        ),
      );
    } else {
      await cubit.updateTask(
        TaskItem(
          id: initial.id,
          title: result.title,
          time: result.time,
          completed: initial.completed,
          category: result.category,
          date: result.date,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        title: const Text('Tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openForm(context),
          ),
        ],
      ),
      body: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          if (state.status == TasksStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == TasksStatus.error) {
            return Center(child: Text('Error: ${state.errorMessage ?? ''}'));
          }
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _FilterBar(
                current: state.filter,
                onChange: (f) => context.read<TasksCubit>().changeFilter(f),
              ),
              const SizedBox(height: 20),
              const _SectionTitle('Hoy'),
              const SizedBox(height: 10),
              _TaskList(
                tasks: state.todayTasks,
                emptyLabel: 'Sin tareas para hoy',
              ),
              const SizedBox(height: 24),
              const _SectionTitle('Mañana'),
              const SizedBox(height: 10),
              _TaskList(
                tasks: state.tomorrowTasks,
                emptyLabel: 'Sin tareas para mañana',
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      );
}

class _TaskList extends StatelessWidget {
  final List<TaskItem> tasks;
  final String emptyLabel;
  const _TaskList({required this.tasks, required this.emptyLabel});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          emptyLabel,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      );
    }
    return Column(
      children: [
        for (final t in tasks) ...[
          _DismissibleTask(task: t),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _DismissibleTask extends StatelessWidget {
  final TaskItem task;
  const _DismissibleTask({required this.task});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TasksCubit>();
    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.danger,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => cubit.deleteTask(task.id),
      child: GestureDetector(
        onTap: () => _editTask(context),
        child: TaskTile(
          task: task,
          onToggle: () => cubit.toggleCompleted(task),
        ),
      ),
    );
  }

  Future<void> _editTask(BuildContext context) async {
    final cubit = context.read<TasksCubit>();
    final result = await showTaskFormSheet(context, initial: task);
    if (result == null) return;
    await cubit.updateTask(
      TaskItem(
        id: task.id,
        title: result.title,
        time: result.time,
        completed: task.completed,
        category: result.category,
        date: result.date,
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final TaskFilter current;
  final ValueChanged<TaskFilter> onChange;

  const _FilterBar({required this.current, required this.onChange});

  @override
  Widget build(BuildContext context) {
    const labels = {
      TaskFilter.todas: 'Todas',
      TaskFilter.personal: 'Personal',
      TaskFilter.academica: 'Académica',
      TaskFilter.salud: 'Salud',
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final entry in labels.entries) ...[
            _Chip(
              label: entry.value,
              selected: current == entry.key,
              onTap: () => onChange(entry.key),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
