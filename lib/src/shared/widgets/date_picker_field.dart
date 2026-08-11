import 'package:flutter/material.dart';

import 'package:app/src/core/theme/app_spacing.dart';

/// Campo tipo selector de fecha/mes: caja con borde, ícono de calendario a la
/// izquierda (en primario) y el texto a su lado. Al tocar dispara [onTap], que
/// normalmente abre el date picker nativo. Único componente para todas las
/// pantallas que eligen una fecha o un mes.
class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.fieldRadius,
      child: Container(
        height: AppSpacing.touchTarget,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadius.fieldRadius,
          border: Border.all(color: theme.dividerColor),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 18, color: theme.colorScheme.primary),
            AppSpacing.gapSm,
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
