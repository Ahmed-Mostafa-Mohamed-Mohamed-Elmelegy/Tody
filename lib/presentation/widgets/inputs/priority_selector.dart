import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tody/core/constants/constants.dart';
import 'package:tody/data/models/todo_model.dart';

/// Reusable priority selector widget
class PrioritySelector extends StatelessWidget {
  final Priority selectedPriority;
  final void Function(Priority) onPriorityChanged;

  const PrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.taskPriority,
          style: TextStyle(
            fontSize: AppSizes.fontM,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : AppColors.textPrimary,
          ),
        ),
        AppSizes.verticalSpaceS,
        Row(
          children: Priority.values.map((priority) {
            final isSelected = selectedPriority == priority;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: priority != Priority.high ? AppSizes.paddingS : 0,
                ),
                child: _PriorityChip(
                  priority: priority,
                  isSelected: isSelected,
                  onTap: () => onPriorityChanged(priority),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final Priority priority;
  final bool isSelected;
  final VoidCallback onTap;

  const _PriorityChip({
    required this.priority,
    required this.isSelected,
    required this.onTap,
  });

  Color get _color {
    switch (priority) {
      case Priority.high:
        return AppColors.priorityHigh;
      case Priority.medium:
        return AppColors.priorityMedium;
      case Priority.low:
        return AppColors.priorityLow;
    }
  }

  String get _label {
    switch (priority) {
      case Priority.high:
        return AppStrings.priorityHigh;
      case Priority.medium:
        return AppStrings.priorityMedium;
      case Priority.low:
        return AppStrings.priorityLow;
    }
  }

  IconData get _icon {
    switch (priority) {
      case Priority.high:
        return Iconsax.arrow_up_3;
      case Priority.medium:
        return Iconsax.minus;
      case Priority.low:
        return Iconsax.arrow_down;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingS,
          vertical: AppSizes.paddingS + 4,
        ),
        decoration: BoxDecoration(
          color: isSelected ? _color : _color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(
            color: _color,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _icon,
              size: AppSizes.iconS,
              color: isSelected ? Colors.white : _color,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                _label,
                style: TextStyle(
                  fontSize: AppSizes.fontS,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : _color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
