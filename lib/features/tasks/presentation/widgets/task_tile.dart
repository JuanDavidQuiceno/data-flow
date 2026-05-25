import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/domain/entities/activity.dart';
import '../../domain/entities/task.dart';

class TaskTile extends StatelessWidget {
  final TaskItem task;
  final VoidCallback? onToggle;

  const TaskTile({super.key, required this.task, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _LeadingDot(task: task),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    decoration: task.completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  task.time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _TrailingCheck(task: task, onToggle: onToggle),
        ],
      ),
    );
  }
}

class _LeadingDot extends StatelessWidget {
  final TaskItem task;
  const _LeadingDot({required this.task});

  @override
  Widget build(BuildContext context) {
    if (task.completed) {
      return Container(
        width: 22,
        height: 22,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(Icons.circle, color: Colors.white, size: 8),
        ),
      );
    }
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: task.category.color, width: 2),
      ),
    );
  }
}

class _TrailingCheck extends StatelessWidget {
  final TaskItem task;
  final VoidCallback? onToggle;
  const _TrailingCheck({required this.task, this.onToggle});

  @override
  Widget build(BuildContext context) {
    final color = task.completed ? AppColors.success : task.category.color;
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: task.completed ? color : Colors.transparent,
          border: Border.all(color: color, width: 2),
        ),
        child: task.completed
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : null,
      ),
    );
  }
}
