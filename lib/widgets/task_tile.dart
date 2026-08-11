import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/date_utils.dart';
import '../theme/app_theme.dart' as theme;

class TaskTile extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onCheckboxChanged;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskTile({
    super.key,
    required this.task,
    required this.onCheckboxChanged,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue = AppDateUtils.isOverdue(task.dueDate, task.isCompleted);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? theme.AppTheme.errorColor.withValues(alpha: 0.15) : Colors.red.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: Icon(
          Icons.delete_outline,
          color: theme.AppTheme.errorColor,
          size: 24,
        ),
      ),
      onDismissed: (direction) {
        onDelete();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          gradient: task.isCompleted
              ? LinearGradient(
                  colors: [
                    isDark 
                        ? Colors.grey.withValues(alpha: 0.08)
                        : Colors.grey.withValues(alpha: 0.04),
                    isDark 
                        ? Colors.grey.withValues(alpha: 0.04)
                        : Colors.transparent,
                  ],
                )
              : null,
          color: task.isCompleted ? null : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (isOverdue && !task.isCompleted)
              BoxShadow(
                color: theme.AppTheme.errorColor.withValues(alpha: 0.12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            if (!task.isCompleted)
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
          ],
          border: isOverdue && !task.isCompleted
              ? Border.all(color: theme.AppTheme.errorColor.withValues(alpha: 0.25), width: 1)
              : Border.all(
                  color: isDark 
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.04),
                  width: 0.5,
                ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => onCheckboxChanged(!task.isCompleted),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: task.isCompleted
                        ? theme.AppTheme.successColor
                        : Colors.transparent,
                    border: Border.all(
                      color: task.isCompleted
                          ? theme.AppTheme.successColor
                          : (isDark 
                              ? Colors.white.withValues(alpha: 0.2)
                              : Colors.black.withValues(alpha: 0.15)),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: task.isCompleted
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 20,
                          )
                        : Icon(
                            Icons.radio_button_unchecked_rounded,
                            color: isDark 
                                ? Colors.white.withValues(alpha: 0.4)
                                : Colors.black.withValues(alpha: 0.3),
                            size: 20,
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            height: 1.3,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: task.isCompleted
                                ? (isDark 
                                    ? Colors.white.withValues(alpha: 0.3)
                                    : theme.AppTheme.secondaryTextColor.withValues(alpha: 0.4))
                                : null,
                            decorationThickness: 1.5,
                            color: task.isCompleted
                                ? (isDark 
                                    ? Colors.white.withValues(alpha: 0.5)
                                    : theme.AppTheme.secondaryTextColor.withValues(alpha: 0.5))
                                : Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (task.description != null && task.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: task.isCompleted
                                  ? (isDark 
                                      ? Colors.white.withValues(alpha: 0.4)
                                      : theme.AppTheme.secondaryTextColor.withValues(alpha: 0.35))
                                  : Theme.of(context).textTheme.bodyMedium?.color,
                              fontSize: 13,
                              height: 1.4,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (task.dueDate != null || task.dueTime != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isOverdue && !task.isCompleted
                                  ? theme.AppTheme.errorColor.withValues(alpha: 0.08)
                                  : (task.isCompleted
                                      ? theme.AppTheme.successColor.withValues(alpha: 0.08)
                                      : theme.AppTheme.accentColor.withValues(alpha: 0.08)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isOverdue && !task.isCompleted
                                      ? Icons.warning_amber_rounded
                                      : (task.isCompleted
                                          ? Icons.check_circle_rounded
                                          : Icons.calendar_today_rounded),
                                  size: 12,
                                  color: isOverdue && !task.isCompleted
                                      ? theme.AppTheme.errorColor
                                      : (task.isCompleted
                                          ? theme.AppTheme.successColor
                                          : theme.AppTheme.accentColor),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  isOverdue && !task.isCompleted
                                      ? AppDateUtils.getOverdueText(task.dueDate)
                                      : AppDateUtils.getTaskDateTime(task.dueDate, task.dueTime),
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: isOverdue && !task.isCompleted
                                            ? theme.AppTheme.errorColor
                                            : (task.isCompleted
                                                ? theme.AppTheme.successColor
                                                : theme.AppTheme.accentColor),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onEdit,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark 
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      size: 18,
                      color: theme.AppTheme.accentColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.AppTheme.errorColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.delete_rounded,
                      size: 18,
                      color: theme.AppTheme.errorColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
