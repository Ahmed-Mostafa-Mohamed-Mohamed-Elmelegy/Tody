import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:tody/core/constants/constants.dart';
import 'package:tody/data/models/todo_model.dart';

/// Reusable todo card widget
class TodoCard extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  final int animationIndex;

  const TodoCard({
    super.key,
    required this.todo,
    this.onTap,
    this.onToggle,
    this.onDelete,
    this.animationIndex = 0,
  });

  Color get _priorityColor {
    switch (todo.priority) {
      case Priority.high:
        return AppColors.priorityHigh;
      case Priority.medium:
        return AppColors.priorityMedium;
      case Priority.low:
        return AppColors.priorityLow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSizes.paddingL),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
        ),
        child: const Icon(
          Iconsax.trash,
          color: Colors.white,
          size: AppSizes.iconL,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black26
                    : AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Priority indicator
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: _priorityColor,
                    ),
                  ),
                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingM),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Checkbox
                          _buildCheckbox(isDark),
                          AppSizes.horizontalSpaceM,
                          // Task details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  todo.title,
                                  style: TextStyle(
                                    fontSize: AppSizes.fontL,
                                    fontWeight: FontWeight.w600,
                                    color: todo.isCompleted
                                        ? AppColors.textSecondary
                                        : (isDark
                                            ? Colors.white
                                            : AppColors.textPrimary),
                                    decoration: todo.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (todo.description?.isNotEmpty ?? false) ...[
                                  AppSizes.verticalSpaceXS,
                                  Text(
                                    todo.description!,
                                    style: TextStyle(
                                      fontSize: AppSizes.fontM,
                                      color: AppColors.textSecondary,
                                      decoration: todo.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                AppSizes.verticalSpaceS,
                                // Meta info row
                                _buildMetaRow(isDark),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(bool isDark) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: todo.isCompleted ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: todo.isCompleted
                ? AppColors.primary
                : AppColors.textSecondary.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: todo.isCompleted
            ? const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 18,
              )
            : null,
      ),
    );
  }

  Widget _buildMetaRow(bool isDark) {
    return Wrap(
      spacing: AppSizes.paddingM,
      runSpacing: AppSizes.paddingXS,
      children: [
        // Category chip
        _MetaChip(
          icon: Iconsax.folder_2,
          label: todo.category,
          color: AppColors.primary,
        ),
        // Due date
        if (todo.dueDate != null)
          _MetaChip(
            icon: Iconsax.calendar_1,
            label: _formatDueDate(todo.dueDate!),
            color: todo.isOverdue ? AppColors.error : AppColors.textSecondary,
          ),
      ],
    );
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dueDay = DateTime(date.year, date.month, date.day);

    if (dueDay == today) {
      return 'Today';
    } else if (dueDay == tomorrow) {
      return 'Tomorrow';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: AppSizes.iconS,
          color: color,
        ),
        AppSizes.horizontalSpaceXS,
        Text(
          label,
          style: TextStyle(
            fontSize: AppSizes.fontS,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
