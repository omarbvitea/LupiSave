import 'package:flutter/material.dart';

import 'package:app/src/core/budget/budget.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/core/theme/app_spacing.dart';

/// Selector de categoría (P2, RN-21): las dos opciones siempre visibles, sin
/// desplegable ni sugerencias. El usuario decide; el sistema no infiere.
class CategorySelector extends StatelessWidget {
  const CategorySelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final ExpenseCategory? value;
  final ValueChanged<ExpenseCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final category in ExpenseCategory.values) ...[
          if (category != ExpenseCategory.values.first) AppSpacing.gapSm,
          Expanded(
            child: _Option(
              label: category.label,
              selected: category == value,
              onTap: () => onChanged(category),
            ),
          ),
        ],
      ],
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.buttonRadius,
      child: Container(
        height: AppSpacing.touchTarget,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : theme.colorScheme.surface,
          borderRadius: AppRadius.buttonRadius,
          border: Border.all(
            color: selected ? AppColors.primary : theme.dividerColor,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            color: selected ? AppColors.onPrimary : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
