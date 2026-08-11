import 'package:flutter/material.dart';

import 'package:app/src/core/theme/app_spacing.dart';

/// Tarjeta genérica de la app. Base visual de todo lo que sea "una caja de
/// contenido": disponible, sobres, ahorro, ítems de lista, etc.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.onTap,
    this.color,
    this.borderColor,
    this.backgroundPainter,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;

  /// Patrón sutil pintado detrás del contenido, recortado al radio de la card.
  final CustomPainter? backgroundPainter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Container(
      padding: backgroundPainter == null ? padding : null,
      clipBehavior: backgroundPainter == null ? Clip.none : Clip.antiAlias,
      decoration: BoxDecoration(
        color: color ?? theme.colorScheme.surface,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(
          color: borderColor ?? theme.dividerColor,
        ),
      ),
      child: backgroundPainter == null
          ? child
          : Stack(
              children: [
                Positioned.fill(child: CustomPaint(painter: backgroundPainter)),
                Padding(padding: padding, child: child),
              ],
            ),
    );

    if (onTap == null) return content;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.cardRadius,
      child: content,
    );
  }
}
