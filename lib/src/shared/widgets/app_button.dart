import 'package:flutter/material.dart';

import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/core/theme/app_spacing.dart';

/// Botón principal de la app: acción positiva/confirmatoria (Guardar, Agregar).
/// Ocupa el ancho disponible por defecto y respeta el objetivo táctil mínimo.
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final child = FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        minimumSize: const Size(0, AppSpacing.touchTarget),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: _content(),
    );
    return expand ? SizedBox(width: double.infinity, child: child) : child;
  }

  Widget _content() {
    if (icon == null) return Text(label);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        AppSpacing.gapXs,
        Text(label),
      ],
    );
  }
}

/// Botón secundario: acción alternativa o de menor jerarquía (Cancelar, editar).
/// Mismo tamaño y radio que el primario, pero con contorno en vez de relleno.
class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final child = OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(0, AppSpacing.touchTarget),
        side: const BorderSide(color: AppColors.primary),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
        textStyle: theme.textTheme.labelLarge,
      ),
      child: icon == null
          ? Text(label)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(icon, size: 18), AppSpacing.gapXs, Text(label)],
            ),
    );
    return expand ? SizedBox(width: double.infinity, child: child) : child;
  }
}
