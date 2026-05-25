import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/repositories/tasks_repository_impl.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../widgets/task_tile.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TasksRepository _repository = TasksRepositoryImpl();
  TaskFilter _filter = TaskFilter.todas;

  late Future<List<TaskItem>> _today;
  late Future<List<TaskItem>> _tomorrow;

  @override
  void initState() {
    super.initState();
    _today = _repository.getTodayTasks();
    _tomorrow = _repository.getTomorrowTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        title: const Text('Tareas'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _FilterBar(
            current: _filter,
            onChange: (f) => setState(() => _filter = f),
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Hoy'),
          const SizedBox(height: 10),
          _TaskList(future: _today),
          const SizedBox(height: 24),
          const _SectionTitle('Mañana'),
          const SizedBox(height: 10),
          _TaskList(future: _tomorrow),
        ],
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
  final Future<List<TaskItem>> future;
  const _TaskList({required this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TaskItem>>(
      future: future,
      builder: (context, snap) {
        if (!snap.hasData) return const SizedBox.shrink();
        return Column(
          children: [
            for (final t in snap.data!) ...[
              TaskTile(task: t),
              const SizedBox(height: 10),
            ],
          ],
        );
      },
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
