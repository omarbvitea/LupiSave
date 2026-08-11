import 'package:flutter/material.dart';

import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/core/theme/app_spacing.dart';

/// Barra de navegación inferior tipo píldora (Layout §5). Por ahora solo el
/// botón Inicio navega; el resto es UI.
///
/// ponytail: tabs decorativos; cablear a un IndexedStack cuando exista una
/// pantalla de nivel superior para cada uno.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    this.activeIndex = -1,
    this.onInicio,
    this.onGastos,
    this.onNuevo,
    this.onAhorros,
    this.onGastosHub,
  });

  /// Índice resaltado (0 = Inicio). -1 no resalta ninguno.
  final int activeIndex;

  /// Acción del botón Inicio. Si es null, no hace nada.
  final VoidCallback? onInicio;

  /// Acción del botón Gastos. Si es null, no hace nada.
  final VoidCallback? onGastos;

  /// Acción del botón "+" (nuevo gasto). Si es null, no hace nada.
  final VoidCallback? onNuevo;

  /// Acción del botón Ahorros. Si es null, no hace nada.
  final VoidCallback? onAhorros;

  /// Acción del botón Gastos (hub de gastos fijos y cuotas). Si es null, no hace
  /// nada.
  final VoidCallback? onGastosHub;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs + 4,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.pill)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2E1E143C),
            blurRadius: 28,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _NavItem(
              icon: Icons.home_rounded,
              label: 'Inicio',
              active: activeIndex == 0,
              onTap: onInicio,
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.savings_outlined,
              label: 'Ahorros',
              active: activeIndex == 3,
              onTap: onAhorros,
            ),
          ),
          _NavFab(onTap: onNuevo),
          Expanded(
            child: _NavItem(
              icon: Icons.receipt_long_outlined,
              label: 'Historial',
              active: activeIndex == 1,
              onTap: onGastos,
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.payments_outlined,
              label: 'Gastos',
              active: activeIndex == 2,
              onTap: onGastosHub,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final resolved = active
        ? AppColors.primary
        : Theme.of(context).textTheme.bodySmall?.color ??
              Theme.of(context).colorScheme.onSurface;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.chipRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: resolved),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: resolved,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavFab extends StatelessWidget {
  const _NavFab({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: AppSpacing.touchTarget / 2,
      child: Container(
        width: AppSpacing.touchTarget,
        height: AppSpacing.touchTarget,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x667C5CFF),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add, size: 28, color: AppColors.onPrimary),
      ),
    );
  }
}
