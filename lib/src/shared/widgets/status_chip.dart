import 'package:flutter/material.dart';

import 'package:app/src/core/theme/app_spacing.dart';

/// Chip de estado (design system). Píldora con texto y color semántico; se usa
/// para la vigencia de las cuotas (Vigente / Futura / Finalizada).
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required this.color,
    required this.surface,
  });

  final String label;
  final Color color;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: AppRadius.chipRadius,
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
