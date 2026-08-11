import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/core/theme/app_spacing.dart';
import 'package:app/src/shared/widgets/app_card.dart';
import 'package:app/src/shared/widgets/hero_pattern_painter.dart';
import 'package:app/src/shared/widgets/money_text.dart';
import 'package:app/src/features/budget/budget_providers.dart';
import 'package:app/src/features/savings/savings_providers.dart';

/// Pantalla de Ahorros (P7). Vive como vista de nivel tab (con footer): hero del
/// ahorro acumulado y las dos cifras del mes (apartado y remanente). Sin flecha
/// de retroceso; se sale por el footer.
class SavingsScreen extends ConsumerWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final balance = ref.watch(savingsBalanceCentsProvider);
    final s = ref.watch(periodSummaryProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            110,
          ),
          children: [
            Text('Ahorros', style: theme.textTheme.titleLarge),
            AppSpacing.gapMd,
            _AccumulatedCard(cents: balance),
            AppSpacing.gapMd,
            Text('Este mes', style: theme.textTheme.titleSmall),
            AppSpacing.gapSm,
            _MonthCard(
              label: 'Ahorro apartado',
              cents: s.savingsCents,
              caption: 'Transferido al inicio del mes',
              trailing: const _Badge(
                color: AppColors.positive,
                icon: Icons.check,
              ),
            ),
            AppSpacing.gapSm,
            _MonthCard(
              label: 'Restante del mes',
              cents: s.netRemainderCents,
              caption: 'Disponible al cerrar el mes',
              trailing: const _Badge(
                color: AppColors.warning,
                icon: Icons.hourglass_empty,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Hero del ahorro acumulado: violeta de marca, ancho completo, con Lupi anclada
/// abajo-derecha.
class _AccumulatedCard extends StatelessWidget {
  const _AccumulatedCard({required this.cents});

  final int cents;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.brightness == Brightness.dark
        ? AppColors.accentDark
        : AppColors.accentLight;
    final ink = theme.colorScheme.onSurface;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AppCard(
          color: accent,
          borderColor: accent,
          backgroundPainter: HeroRipplePainter(color: ink),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Ahorro acumulado',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: ink.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              MoneyText.cents(
                cents,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: ink,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 4,
          bottom: -24,
          child: Image.asset(
            'assets/images/lupi_savings.webp',
            height: 130,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

/// Card básica de una cifra del mes: etiqueta, monto, caption y un ícono a la
/// derecha.
class _MonthCard extends StatelessWidget {
  const _MonthCard({
    required this.label,
    required this.cents,
    required this.caption,
    required this.trailing,
  });

  final String label;
  final int cents;
  final String caption;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                MoneyText.cents(cents, style: theme.textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  caption,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapSm,
          trailing,
        ],
      ),
    );
  }
}

/// Círculo de color con un ícono blanco al centro.
class _Badge extends StatelessWidget {
  const _Badge({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, size: 18, color: AppColors.onPrimary),
    );
  }
}
