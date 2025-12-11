import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:tody/core/constants/constants.dart';

/// Reusable date picker field widget
class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(DateTime?) onDateSelected;
  final bool showClearButton;

  const DatePickerField({
    super.key,
    required this.label,
    this.selectedDate,
    this.firstDate,
    this.lastDate,
    required this.onDateSelected,
    this.showClearButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppSizes.fontM,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : AppColors.textPrimary,
          ),
        ),
        AppSizes.verticalSpaceS,
        InkWell(
          onTap: () => _selectDate(context),
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingM,
              vertical: AppSizes.paddingM,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.cardBackgroundDark
                  : AppColors.background,
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : AppColors.textSecondary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.calendar_1,
                  color: AppColors.textSecondary,
                  size: AppSizes.iconM,
                ),
                AppSizes.horizontalSpaceM,
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? DateFormat('EEE, MMM d, yyyy').format(selectedDate!)
                        : 'Select date',
                    style: TextStyle(
                      fontSize: AppSizes.fontL,
                      color: selectedDate != null
                          ? (isDark ? Colors.white : AppColors.textPrimary)
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                if (showClearButton && selectedDate != null)
                  GestureDetector(
                    onTap: () => onDateSelected(null),
                    child: const Icon(
                      Iconsax.close_circle,
                      color: AppColors.textSecondary,
                      size: AppSizes.iconM,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: firstDate ?? now,
      lastDate: lastDate ?? DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }
}
